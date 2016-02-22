//
//  TripDetailViewController.swift
//  Flights
//
//  Created by Kyle Yoon on 2/21/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import UIKit

class TripDetailViewController: UIViewController {

    @IBOutlet var departureTimeLabel: UILabel!
    @IBOutlet var arrivalTimeLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var durationLabel: UILabel!
    
    var tripOption: TripOption?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tripOption = self.tripOption {
            let departureDateComponents = NSCalendar.currentCalendar().components([.Hour, .Minute], fromDate: tripOption.slice[0].segment[0].leg[0].departureTime)
            self.departureTimeLabel.text = "Departing \(departureDateComponents.hour):\(departureDateComponents.minute)"
            let arrivalDateComponents = NSCalendar.currentCalendar().components([.Hour, .Minute], fromDate: tripOption.slice[0].segment[0].leg[0].arrivalTime)
            self.arrivalTimeLabel.text = "Arriving \(arrivalDateComponents.hour):\(arrivalDateComponents.minute)"
            self.durationLabel.text = "Duration: \(tripOption.slice[0].duration)"
            self.priceLabel.text = "Price: \(tripOption.pricing[0].saleTotal)"
        }
    }
    
}
