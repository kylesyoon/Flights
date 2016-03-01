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
    @IBOutlet var passengersTextField: UITextField!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var roundTripSegmentedControl: UISegmentedControl!
    @IBOutlet var departureDateButton: UIButton!
    @IBOutlet var returnDateButton: UIButton!
    
    var tripsData: JSON?
    var searchResults: SearchResults?
    var departureDate: NSDate?
    var returnDate: NSDate?
    
    @IBAction func didTapSearch(sender: AnyObject) {
        self.activityIndicator.startAnimating()
        if let origin = self.originTextField.text,
            destination = self.destinationTextField.text, 
            passengerCountString = self.passengersTextField.text,
            departureDate = self.departureDate {
                if let passengerCount = Int(passengerCountString) {
                    let tripRequest = TripRequest(origin: origin,
                        destination: destination,
                        date: departureDate,
                        adultPassengerCount: passengerCount)
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
        } else {
            self.showError()
        }
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
                    // Let VC know whether we tapped button for depature or return date
                    dateViewController.isDeparture = segue.identifier == DateViewController.departureDateSegueIdentifier
                    dateViewController.delegate = self
                }
                datePopoverNavController.preferredContentSize = CGSizeMake(self.view.frame.size.width, 150)
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
    
    @IBAction func unwindFromDatePopoverController(sender: AnyObject) {
        
    }
    
    private func showError() {
        let errorAlert = UIAlertController(title: "Error",
            message: "Sorry try again I guess?", 
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
            self.departureDate = date
            self.departureDateButton.setTitle(NSDateFormatter.presentableDate(fromDate: date), forState: .Normal)
        } else {
            if let departureDate = self.departureDate {
                if date.compare(departureDate) == NSComparisonResult.OrderedAscending {
                    // If the return date is earlier than the departure date, do nothing.
                    return;
                }
            }
            self.returnDate = date
            self.returnDateButton.setTitle(NSDateFormatter.presentableDate(fromDate: date), forState: .Normal)
        }
    }
    
}

