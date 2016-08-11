//
//  ViewController.swift
//  Flights
//
//  Created by Kyle Yoon on 2/9/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import UIKit
import QPXExpressWrapper

class SearchViewController: UIViewController {
    
    static let flightsViewControllerSegueIdentifier = "searchFlightsSegue"
    
    @IBOutlet var searchStackView: UIStackView!
    @IBOutlet var originTextField: UITextField!
    @IBOutlet var destinationTextField: UITextField!
    @IBOutlet var adultCountTextField: UITextField!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var roundTripSegmentedControl: UISegmentedControl!
    @IBOutlet var departureDateButton: UIButton!
    @IBOutlet var returnDateButton: UIButton!
    
    var searchResults: SearchResults?
    var departureDate: NSDate?
    var returnDate: NSDate?
    var tripRequest: TripRequest?
    //Typeahead
    var editingTextField: UITextField?
    var typeaheadTableView: UITableView?
    var searchTerm: String = ""
    var typeaheadDataSource = TypeaheadDataSource()
    
    var airports: [[String: AnyObject]]?
    var typeaheadResults: [String: [String]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(self.keyboardWillShow(_:)),
                                                         name: UIKeyboardWillShowNotification,
                                                         object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(self.keyboardWillHide(_:)),
                                                         name: UIKeyboardWillHideNotification,
                                                         object: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SearchViewController.flightsViewControllerSegueIdentifier {
            if let tripsVC = segue.destinationViewController as? TripsViewController {
                tripsVC.searchResults = self.searchResults
            }
        } else if segue.identifier == DateViewController.departureDateSegueIdentifier ||
            segue.identifier == DateViewController.returnDateSegueIdentifier {
            if let datePopoverNavController = segue.destinationViewController as? UINavigationController {
                if let dateViewController = datePopoverNavController.viewControllers.first as? DateViewController {
                    // Let VC know whether we tapped button for departure or return date
                    dateViewController.isDeparture = segue.identifier == DateViewController.departureDateSegueIdentifier
                    dateViewController.delegate = self
                }
                datePopoverNavController.preferredContentSize = CGSizeMake(CGRectGetWidth(self.view.frame), self.view.frame.size.height / 4)
                let datePresentationController = datePopoverNavController.popoverPresentationController
                datePresentationController?.delegate = self
                datePresentationController?.permittedArrowDirections = UIPopoverArrowDirection.Up
                if let dateButton = sender as? UIButton {
                    datePresentationController?.sourceRect = dateButton.frame
                    datePresentationController?.sourceView = dateButton
                }
            }
        }
    }
    
    /**
     Making the request to throw into the network call
     
     - returns: The request with user input
     */
    private func tripRequestFromUserInput() -> TripRequest? {
        if let origin = self.originTextField.text,
            destination = self.destinationTextField.text,
            adultCountString = self.adultCountTextField.text,
            departureDate = self.departureDate {
            var slices = [TripRequestSlice]()
            let originCode = origin.substringToIndex(origin.startIndex.advancedBy(3))
            let destinationCode = destination.substringToIndex(destination.startIndex.advancedBy(3))
            let departureTripSlice = TripRequestSlice(origin: originCode,
                                                      destination: destinationCode,
                                                      date: departureDate,
                                                      maxStops: nil,
                                                      maxConnectionDuration: nil,
                                                      preferredCabin: nil,
                                                      permittedDepartureTime: nil,
                                                      permittedCarrier: nil,
                                                      alliance: nil,
                                                      prohibitedCarrier: nil)
            slices.append(departureTripSlice)
            // If it's a round trip, add another slice for return
            if self.roundTripSegmentedControl.selectedSegmentIndex == 0 {
                if let returnDate = self.returnDate {
                    let returnTripSlice = TripRequestSlice(origin: destinationCode,
                                                           destination: originCode,
                                                           date: returnDate,
                                                           maxStops: nil,
                                                           maxConnectionDuration: nil,
                                                           preferredCabin: nil,
                                                           permittedDepartureTime: nil,
                                                           permittedCarrier: nil,
                                                           alliance: nil,
                                                           prohibitedCarrier: nil)
                    slices.append(returnTripSlice)
                }
            }
            // TODO: Add fields for other types of passengers
            if let adultCount = Int(adultCountString) {
                let requestPassengers = TripRequestPassengers(adultCount: adultCount,
                                                              childCount: nil,
                                                              infantInLapCount: nil,
                                                              infantInSeatCount: nil,
                                                              seniorCount: nil)
                
                return TripRequest(passengers: requestPassengers,
                                   slice: slices,
                                   maxPrice: nil,
                                   saleCountry: nil,
                                   refundable: nil,
                                   solutions: nil)
            }
            
            return nil
        }
        
        return nil
    }
    
    /**
     Getting the keyboard height to draw a typeahead tableview above the keyboard
     
     - parameter notification: The notification with the keyboard rect
     */
    @objc private func keyboardWillShow(notification: NSNotification) {
        // Clear typeahead results because this gets called when tapping another textfield
        self.typeaheadDataSource.typeaheadResults.removeAll()
        self.typeaheadTableView?.reloadData()
        // Get the keyboard rect
        let userInfo = notification.userInfo!
        let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        let keyboardRect = keyboardFrame.CGRectValue()
        if let typeaheadTableView = self.typeaheadTableView {
            // when tapping textfield to textfield
            if !typeaheadTableView.hidden {
                // get out since it's already there
                return
                // when showing a hidden tableview
            } else {
                typeaheadTableView.hidden = false
            }
        } else {
            // when its first time
            let typeaheadTableView = UITableView(frame: CGRectMake(0, self.view.frame.size.height, self.view.frame.width, self.view.frame.height - keyboardRect.height))
            typeaheadTableView.backgroundColor = UIColor.whiteColor()
            typeaheadTableView.delegate = self
            typeaheadTableView.dataSource = self
            self.typeaheadTableView = typeaheadTableView
            self.view.addSubview(typeaheadTableView)
        }
        // move the table view up
        if let typeaheadTableView = self.typeaheadTableView {
            let convertedDestinationFieldOrigin = self.view.convertPoint(self.destinationTextField.frame.origin, fromView: self.searchStackView)
            let tableViewOrigin = CGPointMake(0, convertedDestinationFieldOrigin.y + self.destinationTextField.frame.size.height + 20)
            UIView.animateWithDuration(0.2,
                                       animations: {
                                        typeaheadTableView.frame = CGRectMake(tableViewOrigin.x, tableViewOrigin.y, typeaheadTableView.frame.size.width, typeaheadTableView.frame.size.height)
            })
        }
        
    }
    
    /**
     When keyboard hides, remote the typeahead tableview
     
     - parameter notification: The notification that the keyboard is hiding
     */
    @objc private func keyboardWillHide(notification: NSNotification) {
        if let typeaheadTableView = self.typeaheadTableView {
            typeaheadTableView.hidden = true
            typeaheadTableView.frame = CGRectMake(0, self.view.frame.size.height, typeaheadTableView.frame.size.width, typeaheadTableView.frame.size.height)
        }
        
        self.typeaheadDataSource.typeaheadResults.removeAll()
    }

    @IBAction func didTapSearch(sender: AnyObject) {
        // TODO: For roundtrip if there's no return trip date, then don't allow
        if let tripRequest = self.tripRequestFromUserInput() {
            self.tripRequest = tripRequest
            self.activityIndicator.startAnimating()
            TripAPI.searchTripsWithRequest(tripRequest,
                                           success: {
                                            [weak self]
                                            searchResults in
                                            self?.activityIndicator.stopAnimating()
                                            self?.searchResults = searchResults
                                            self?.performSegueWithIdentifier(SearchViewController.flightsViewControllerSegueIdentifier, sender: nil)
                },
                                           failure: {
                                            [weak self]
                                            error in
                                            print("\(error)")
                                            self?.activityIndicator.stopAnimating()
                                            // TODO: Error handling
                })
        } else {
            // TODO: Error handling
        }
    }
    
    @IBAction func valueChangedForSegmentedControl(control: UISegmentedControl) {
        self.returnDateButton.hidden = control.selectedSegmentIndex != 0
    }
    
    @IBAction func didBeingEditing(textField: UITextField) {
        self.editingTextField = textField
    }
    
    @IBAction func didChangeEditing(textField: UITextField) {
        if let text = textField.text {
            if text.characters.count >= 2 {
                self.typeaheadDataSource.searchAirportsWithTerm(text)
                self.typeaheadTableView?.reloadData()
            }
        }
    }
    
    @IBAction func recognizedTapGesture(gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .Ended {
            if let textField = self.editingTextField {
                textField.resignFirstResponder()
            }
        }
    }
    
}

extension SearchViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
}

extension SearchViewController: DateViewControllerDelegate {
    
    func dateViewController(dateViewController: DateViewController, didTapDoneWithDate date: NSDate) {
        if dateViewController.isDeparture {
            TripManager.sharedManager.departureDate = date
            self.departureDate = date
            self.departureDateButton.setTitle(NSDateFormatter.presentableDate(fromDate: date), forState: .Normal)
            // If the user selects a date later than the return date they've specified, then clear return date
            if let returnDate = self.returnDate {
                if  date.compare(returnDate) == .OrderedDescending {
                    self.returnDate = nil
                    self.returnDateButton.setTitle(LocalizedStrings.returnDate, forState: .Normal)
                }
            }
        } else {
            TripManager.sharedManager.returnDate = date
            self.returnDate = date
            self.returnDateButton.setTitle(NSDateFormatter.presentableDate(fromDate: date), forState: .Normal)
            // If the user selects a date earlier than the departure date they've specified, then clear departure date
            if let departureDate = self.departureDate {
                if date.compare(departureDate) == .OrderedAscending {
                    // If the return date is earlier than the departure date, do nothing.
                    self.departureDate = nil
                    self.departureDateButton.setTitle(LocalizedStrings.departureDate, forState: .Normal)
                }
            }
        }
    }
    
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.typeaheadDataSource.numberOfRowsForSection(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let typeAheadCell = UITableViewCell(style: .Default, reuseIdentifier: "typeAheadCell")
        // TODO: Make custom cell to display bolded text
        typeAheadCell.textLabel?.text = self.typeaheadDataSource.stringForIndexPath(indexPath)
        return typeAheadCell
    }
    
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
        if let editingTextField = self.editingTextField {
            editingTextField.text = selectedCell?.textLabel?.text
            editingTextField.resignFirstResponder()
        }
        
    }
    
}

extension SearchViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if let view = touch.view, typeaheadTableView = self.typeaheadTableView {
            if view.isDescendantOfView(typeaheadTableView) || view.isDescendantOfView(self.roundTripSegmentedControl) {
                return false
            }
            
            return true
        }
        
        return true
    }
    
}
