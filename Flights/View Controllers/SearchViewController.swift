//
//  ViewController.swift
//  Flights
//
//  Created by Kyle Yoon on 2/9/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchViewController: UIViewController {

    static let flightsViewControllerSegueIdentifier = "searchFlightsSegue"
    
    @IBOutlet var originTextField: UITextField!
    @IBOutlet var destinationTextField: UITextField!
    @IBOutlet var passengersTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var roundTripSegmentedControl: UISegmentedControl!
    
    var tripsData: JSON?
    var searchResults: SearchResults?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.datePicker.minimumDate = NSDate()
    }
    
    @IBAction func didTapSearch(sender: AnyObject) {
        self.activityIndicator.startAnimating()
        if let origin = self.originTextField.text,
            destination = self.destinationTextField.text, 
            passengerCountString = self.passengersTextField.text {
                if let passengerCount = Int(passengerCountString) {
                    let tripRequest = TripRequest(origin: origin,
                        destination: destination,
                        date: self.datePicker.date,
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
        }
    }
    
    private func showError() {
        let errorAlert = UIAlertController(title: "WTF", message: "Stop it!", preferredStyle: .Alert)
        errorAlert.addAction(UIAlertAction(title: "Sorry", style: .Default, handler: nil))
        self.presentViewController(errorAlert, animated: true, completion: nil)
    }
    
}

