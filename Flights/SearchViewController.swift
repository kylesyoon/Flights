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
                    self.fetchFlightsFromOrigin(origin, toDestination: destination, forNumberOfPassengers: passengerCount, onDate: self.datePicker.date)
                } else {
                    self.showError()
                }
        } else {
            self.showError()
        }
    }
    
    private func fetchFlightsFromOrigin(origin: String, toDestination destination: String, forNumberOfPassengers passengers: Int, onDate date: NSDate) {
        let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let flightsCallComponents = NSURLComponents(string: self.baseURL)
        let keyQueryParam = NSURLQueryItem(name: "key", value: Keys.APIKey)
        flightsCallComponents?.queryItems = [keyQueryParam]
        
        if let flightsURL = flightsCallComponents?.URL {
            
            let flightRequest = NSMutableURLRequest(URL: flightsURL)
            flightRequest.HTTPMethod = "POST"
            flightRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            flightRequest.addValue("application/json", forHTTPHeaderField: "Accept")

            let flightDateComponents = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: date)
            let dateString = "\(flightDateComponents.year)-\(flightDateComponents.month)-\(flightDateComponents.day)"
            
            let flightRequestBody = ["request": ["slice": [["origin": origin, "destination": destination, "date": dateString]], "passengers": ["adultCount": passengers, "infantInLapCount": 0, "infantInSeatCount": 0, "childCount": 0, "seniorCount": 0], "solutions": self.maxSolutions, "refundable": false]]
            
            do {
                let bodyData = try NSJSONSerialization.dataWithJSONObject(flightRequestBody, options: [])
                flightRequest.HTTPBody = bodyData
            } catch {
                print("\(error)")
            }
            
            let dataTask = defaultSession.dataTaskWithRequest(flightRequest, completionHandler: {
                (data, response, error) in
                if let data = data {
                    do {
                        let JSONObject = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                        print("\(JSONObject)")
                    } catch {
                        // I fucking hate this do catch shit
                        print("\(error)")
                    }
                } else {
                    print("\(error)")
                }
            })
            
            dataTask.resume()
        }
    }

    private func showError() {
        let errorAlert = UIAlertController(title: "WTF", message: "Stop it!", preferredStyle: .Alert)
        errorAlert.addAction(UIAlertAction(title: "Sorry", style: .Default, handler: nil))
        self.presentViewController(errorAlert, animated: true, completion: nil)
    }
    
}

