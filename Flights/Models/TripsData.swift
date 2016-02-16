//
//  TripsData.swift
//  Flights
//
//  Created by Kyle Yoon on 2/14/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import Foundation

struct TripsData {
    let kind: String
    let airport: [AnyObject]
    let city: [AnyObject]
    let aircraft: [AnyObject]
    let tax: [AnyObject]
    let carrier: [AnyObject]
    
    init(kind: String,
        airport: [AnyObject],
        city: [AnyObject], 
        aircraft: [AnyObject], 
        tax: [AnyObject], 
        carrier: [AnyObject]) {
            self.kind = kind
            self.airport = airport
            self.city = city
            self.aircraft = aircraft
            self.tax = tax
            self.carrier = carrier
    }
}

extension TripsData {
    static func decode(jsonDict: NSDictionary) -> TripsData? {
        if let kind = jsonDict["kind"] as? String,
            airport = jsonDict["airport"] as? [AnyObject],
            city = jsonDict["city"] as? [AnyObject],
            aircraft = jsonDict["aircraft"] as? [AnyObject],
            tax = jsonDict["tax"] as? [AnyObject],
            carrier = jsonDict["carrier"] as? [AnyObject] {
                return TripsData(kind: kind, airport: airport, city: city, aircraft: aircraft, tax: tax, carrier: carrier)
        }
        
        return nil
    }
}