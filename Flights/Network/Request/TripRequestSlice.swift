//
//  TripRequestSlice.swift
//  Flights
//
//  Created by Kyle Yoon on 3/1/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import Foundation

struct TripRequestSlice {
    
    let kind: String = "qpxexpress#sliceInput"
    let origin: String
    let destination: String
    let date: NSDate
    
    // Not using yet
    let maxStops: Int?
    let maxConnectionDuration: Int?
    let preferredCabin: String?
    let permittedDepartureTime: [String: String]?
    let permittedCarrier: [String]?
    let alliance: String?
    let prohibitedCarrier: [String]?
    
    init(origin: String,
        destination: String,
        date: NSDate,
        maxStops: Int?, 
        maxConnectionDuration: Int?, 
        preferredCabin: String?, 
        permittedDepartureTime: [String: String]?, 
        permittedCarrier: [String]?, 
        alliance: String?, 
        prohibitedCarrier: [String]?) {
            self.origin = origin
            self.destination = destination
            self.date = date
            self.maxStops = maxStops
            self.maxConnectionDuration = maxConnectionDuration
            self.preferredCabin = preferredCabin
            self.permittedDepartureTime = permittedDepartureTime
            self.permittedCarrier = permittedCarrier
            self.alliance = alliance
            self.prohibitedCarrier = prohibitedCarrier
    }
    
    func jsonDict() -> [String: AnyObject] {
        let tripDateComponents = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: self.date)
        let dateString = "\(tripDateComponents.year)-\(tripDateComponents.month)-\(tripDateComponents.day)"
        let jsonDict = ["kind": self.kind,
            "origin": self.origin,
            "destination": self.destination,
            "date": dateString].mutableCopy() as! [String: AnyObject]
        // Add others as needed
        return jsonDict
    }
    
}