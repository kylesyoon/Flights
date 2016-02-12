//
//  ViewController.swift
//  Flights
//
//  Created by Kyle Yoon on 2/9/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    let baseURL = "https://www.googleapis.com/qpxExpress/v1/trips/search"
    let maxSolutions = 20
    static let flightsViewControllerSegueIdentifier = "searchFlightsSegue"
    
    @IBOutlet var originTextField: UITextField!
    @IBOutlet var destinationTextField: UITextField!
    @IBOutlet var passengersTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        self.datePicker.minimumDate = NSDate()
    }
    
    @IBAction func didTapSearch(sender: AnyObject) {
        if let origin = self.originTextField.text,
            destination = self.destinationTextField.text, 
            passengerCountString = self.passengersTextField.text {
                if let passengerCount = Int(passengerCountString) {
                    TripAPI.searchTripsFromOrigin(origin,
                        toDestination: destination,
                        onDate: self.datePicker.date,
                        withNumberOfPassengers: passengerCount,
                        success: {
                            [weak self]
                            dict in
                            self?.performSegueWithIdentifier(SearchViewController.flightsViewControllerSegueIdentifier, sender: nil)
                        },
                        failure: {
                            [weak self]
                            error in
                            self?.showError()
                    } )
                } else {
                    self.showError()
                }
        } else {
            self.showError()
        }
    }

    private func showError() {
        let errorAlert = UIAlertController(title: "WTF", message: "Stop it!", preferredStyle: .Alert)
        errorAlert.addAction(UIAlertAction(title: "Sorry", style: .Default, handler: nil))
        self.presentViewController(errorAlert, animated: true, completion: nil)
    }
    
}

