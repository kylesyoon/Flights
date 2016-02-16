//
//  Flight.swift
//  Flights
//
//  Created by Kyle Yoon on 2/14/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import Foundation

struct Flight {
    let carrier: String
    let number: String
    
    init(number: String, carrier: String) {
        self.number = number
        self.carrier = carrier
    }
}

extension Flight {
    static func decode(jsonDict: [String: AnyObject]) -> Flight? {
        if let number = jsonDict["number"] as? String,
            carrier = jsonDict["carrier"] as? String {
                return Flight(number: number, carrier: carrier)
        }
        
        return nil
    }
}