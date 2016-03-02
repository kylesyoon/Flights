//
//  ViewController.swift
//  Flights
//
//  Created by Kyle Yoon on 2/9/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import UIKit
import SwiftyJSON
import PDTSimpleCalendar

class SearchViewController: UIViewController {

    static let flightsViewControllerSegueIdentifier = "searchFlightsSegue"
    
    @IBOutlet var originTextField: UITextField!
    @IBOutlet var destinationTextField: UITextField!
    @IBOutlet var adultCountTextField: UITextField!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var roundTripSegmentedControl: UISegmentedControl!
    @IBOutlet var departureDateButton: UIButton!
    @IBOutlet var returnDateButton: UIButton!
    
    var tripsData: JSON?
    var searchResults: SearchResults?
    var departureDate: NSDate?
    var returnDate: NSDate?
    var departureTripRequest: TripRequest?
    
    @IBAction func didTapSearch(sender: AnyObject) {
        self.activityIndicator.startAnimating()
        if let tripRequest = self.tripRequestFromUserInput() {
            self.departureTripRequest = tripRequest
            TripAPI.searchTripsWithRequest(tripRequest,
                success: {
                    [weak self]
                    searchResults in
                    self?.activityIndicator.stopAnimating()
                    self?.searchResults = searchResults
                    self?.performSegueWithIdentifier(SearchViewController.flightsViewControllerSegueIdentifier, sender: nil)
                }, failure: {
                    [weak self]
                    error in
                    self?.activityIndicator.stopAnimating()
                    self?.showError()
                })
        } else {
            self.showError()
        }
    }
    
    @IBAction func valueChangedForSegmentedControl(control: UISegmentedControl) {
            self.returnDateButton.hidden = control.selectedSegmentIndex != 0
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SearchViewController.flightsViewControllerSegueIdentifier {
            if let tripsVC = segue.destinationViewController as? TripsViewController {
                tripsVC.searchResults = self.searchResults
                tripsVC.departureTripRequest = self.departureTripRequest // TODO: Pass this only when we have round trip! Should we query before we go to next screen?
                tripsVC.isRoundTrip = self.roundTripSegmentedControl.selectedSegmentIndex == 0 // For round trip
            }
        } else if segue.identifier == DateViewController.departureDateSegueIdentifier ||
            segue.identifier == DateViewController.returnDateSegueIdentifier {
            if let datePopoverNavController = segue.destinationViewController as? UINavigationController {
                if let dateViewController = datePopoverNavController.viewControllers.first as? DateViewController {
                    // Let VC know whether we tapped button for depature or return date
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
    
    private func tripRequestFromUserInput() -> TripRequest? {
        if let origin = self.originTextField.text,
            destination = self.destinationTextField.text,
            adultCountString = self.adultCountTextField.text,
            departureDate = self.departureDate {
                var slices = [TripRequestSlice]()
                let departureTripSlice = TripRequestSlice(origin: origin,
                    destination: destination,
                    date: departureDate,
                    maxStops: nil,
                    maxConnectionDuration: nil,
                    preferredCabin: nil,
                    permittedDepartureTime: nil,
                    permittedCarrier: nil,
                    alliance: nil,
                    prohibitedCarrier: nil)
                slices.append(departureTripSlice)
                
                if self.roundTripSegmentedControl.selectedSegmentIndex == 0 {
                    if let returnDate = self.returnDate {
                        let returnTripSlice = TripRequestSlice(origin: destination,
                            destination: origin,
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
                
                if let adultCount = Int(adultCountString) {
                    let requestPassengers = TripRequestPassengers(adultCount: adultCount, // Force trusting that it will be in Int. Investigate later.
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
    
    private func showError() {
        let errorAlert = UIAlertController(title: "Error",
            message: "Sorry, try again I guess?", 
            preferredStyle: .Alert)
        errorAlert.addAction(UIAlertAction(title: "Okay",
            style: .Default,
            handler: nil))
        self.presentViewController(errorAlert, 
            animated: true, 
            completion: nil)
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
            // TODO: Set minimum date for return date
        } else {
            if let departureDate = self.departureDate {
                if date.compare(departureDate) == NSComparisonResult.OrderedAscending {
                    // If the return date is earlier than the departure date, do nothing.
                    return;
                }
            }
            TripManager.sharedManager.returnDate = date
            self.returnDate = date
            self.returnDateButton.setTitle(NSDateFormatter.presentableDate(fromDate: date), forState: .Normal)
        }
    }
    
}

