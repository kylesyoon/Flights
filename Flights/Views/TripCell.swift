//
//  TripCell.swift
//  Flights
//
//  Created by Kyle Yoon on 2/29/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import UIKit
import QPXExpressWrapper

class TripCell: UITableViewCell {
    
    static let cellIdentifier = "TripCell"
    
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var airlineLogoImageView: UIImageView!
    @IBOutlet var flightTimeLabel: UILabel!
    @IBOutlet var airlineLabel: UILabel!
    @IBOutlet var detailsLabel: UILabel!
    @IBOutlet var layoverLabel: UILabel!
    
    internal func configure(with sourceFlight: SourceFlight) {
        let tripOption = sourceFlight.tripOption
        let sliceIndex = sourceFlight.sliceIndex
        self.configurePrice(tripOption)
        let slice = tripOption.slice[sliceIndex]
        self.configureFlightTimes(slice)
        self.configureCarrierNames(sourceFlight.airlineNames)
        self.configureLayovers(slice)
    }
    
//    internal func configure(with tripCellData: TripCellData) {
//        let tripOption = tripCellData.tripOption
//        let sliceIndex = tripCellData.sliceIndex
//        self.configurePrice(tripOption)
//        let slice = tripOption.slice[sliceIndex]
//        self.configureFlightTimes(slice)
//        self.configureCarrierNames(tripCellData.airlineNames)
//        self.configureLayovers(slice)
//    }

    private func configurePrice(tripOption: TripOption) {
        //TODO: Get the right price
        let saleTotal = tripOption.pricing[0].saleTotal // When do we have more than 1 pricing?
        if saleTotal.hasPrefix("USD") {
            self.priceLabel.text = "$" + (saleTotal as NSString).substringFromIndex(3)
        }
    }
    
    private func configureFlightTimes(slice: TripOptionSlice) {
        if let firstLeg = slice.segment.first?.leg.first, lastLeg = slice.segment.last?.leg.last {
            let departureTime = firstLeg.departureTime
            let arrivalTime = lastLeg.arrivalTime
            let departureString = NSDateFormatter.presentableTime(fromDate: departureTime)
            let arrivalString = NSDateFormatter.presentableTime(fromDate: arrivalTime)
            self.flightTimeLabel.text = departureString + "-" + arrivalString
            let durationComponents = NSCalendar.currentCalendar().components([.Day, .Hour, .Minute],
                fromDate: departureTime,
                toDate: arrivalTime,
                options: [])
            let duration = "\(durationComponents.hour)h:\(durationComponents.minute)m"
            self.detailsLabel.text = duration + " " + "\(firstLeg.origin)" + "-" + "\(lastLeg.destination)"
        }
    }
    
    private func configureCarrierNames(names: [String]) {
        self.airlineLabel.text = ""
        for airlineName in names {
            self.airlineLabel.text! += airlineName
            if names.last != airlineName {
                self.airlineLabel.text! += ", "
            }
        }
    }
    
    private func configureLayovers(slice: TripOptionSlice) {
        var connectionDurationsAndAirports = [(Int, String)]()
        for segment in slice.segment {
            for leg in segment.leg {
                if let connectionDuration = leg.connectionDuration {
                    connectionDurationsAndAirports.append((connectionDuration, leg.destination))
                }
            }
            if let connectionDuration = segment.connectionDuration {
                if let lastLegOfSegment = segment.leg.last {
                    connectionDurationsAndAirports.append((connectionDuration, lastLegOfSegment.destination))
                }
            }
        }
        let stopCount = connectionDurationsAndAirports.count
        if stopCount > 0 {
            self.layoverLabel.hidden = false
            // If there are more than one stop, then list them out underneath
            self.layoverLabel.text = "\(stopCount) \(stopCount > 1 ? "stops\n" : "stop")" + " "
            for connectionDurationAndAirport in connectionDurationsAndAirports {
                var layoverDetails = ""
                if connectionDurationAndAirport.0 / 60 > 1 {
                    layoverDetails = layoverDetails + "\(Int(connectionDurationAndAirport.0 / 60))h" + " "
                }
                layoverDetails = layoverDetails + "\(connectionDurationAndAirport.0 % 60)m" + " in " + connectionDurationAndAirport.1
                // If it's not the last one, then add a new line
                if connectionDurationsAndAirports.last! != connectionDurationAndAirport {
                    layoverDetails = layoverDetails + "\n"
                }
                self.layoverLabel.text = self.layoverLabel.text! + layoverDetails
            }
        } else {
            self.layoverLabel.hidden = true
        }
    }
    
}
