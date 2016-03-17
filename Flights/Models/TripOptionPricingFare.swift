//
//  TripOptionPricingFare.swift
//  Flights
//
//  Created by Kyle Yoon on 3/5/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import Foundation

struct TripOptionPricingFare {
    let kind: String
    let identifier: String
    let carrier: String
    let origin: String
    let destination: String
    let basisCode: String
    
    init(kind: String, identifier: String, carrier: String, origin: String, destination: String, basisCode: String) {
        self.kind = kind
        self.identifier = identifier
        self.carrier = carrier
        self.origin = origin
        self.destination = destination
        self.basisCode = basisCode
    }
    
    static func decode(jsonDict: [String: AnyObject]) -> TripOptionPricingFare? {
        if let kind = jsonDict["kind"] as? String,
            identifier = jsonDict["id"] as? String,
            carrier = jsonDict["carrier"] as? String, 
            origin = jsonDict["origin"] as? String, 
            destination = jsonDict["destination"] as? String, 
            basisCode = jsonDict["basisCode"] as? String {
                return TripOptionPricingFare(kind: kind,
                    identifier: identifier, 
                    carrier: carrier, 
                    origin: origin, 
                    destination: destination, 
                    basisCode: basisCode);
        }
        
        return nil
    }
}

extension TripOptionPricingFare: Equatable {}

func ==(lhs: TripOptionPricingFare, rhs: TripOptionPricingFare) -> Bool {
    return lhs.kind == rhs.kind &&
        lhs.identifier == rhs.identifier &&
        lhs.carrier == rhs.carrier &&
        lhs.origin == rhs.origin &&
        lhs.destination == rhs.destination &&
        lhs.basisCode == rhs.basisCode
}
