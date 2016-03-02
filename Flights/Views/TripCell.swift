//
//  TripCell.swift
//  Flights
//
//  Created by Kyle Yoon on 2/29/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import UIKit

class TripCell: UITableViewCell {
    
    static let cellIdentifier = "TripCell"
    
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var airlineLogoImageView: UIImageView!
    @IBOutlet var flightTimeLabel: UILabel!
    @IBOutlet var airlineLabel: UILabel!
    @IBOutlet var detailsLabel: UILabel!
    @IBOutlet var layoverLabel: UILabel!
    
    func configure(tripOption: TripOption) {
        let saleTotal = tripOption.pricing[0].saleTotal
        if saleTotal.hasPrefix("USD") {
            self.priceLabel.text = "$" + (saleTotal as NSString).substringFromIndex(3)
        }
        let leg = tripOption.slice[0].segment[0].leg[0] // TODO: Investigate why we get 0 legs?
        let departureTime = leg.departureTime
        let arrivalTime = leg.arrivalTime
        let departureString = NSDateFormatter.presentableTime(fromDate: departureTime)
        let arrivalString = NSDateFormatter.presentableTime(fromDate: arrivalTime)
        self.flightTimeLabel.text = departureString + "-" + arrivalString
        // TODO: Parse TripData, check all segments, reference TripData for carrier full name
        // Carrier name for code function
        self.airlineLabel.text = tripOption.slice[0].segment[0].flight.carrier
        
        let durationComponents = NSCalendar.currentCalendar().components([.Day, .Hour, .Minute],
            fromDate: departureTime,
            toDate: arrivalTime,
            options: [])
        let duration = "\(durationComponents.hour)h:\(durationComponents.minute)m"
        self.detailsLabel.text = duration + " " + "\(leg.origin)" + "-" + "\(leg.destination)"
        self.layoverLabel.text = "How do I know layovers?"
    }
    
}
