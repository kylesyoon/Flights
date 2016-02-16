//
//  TripOption.swift
//  Flights
//
//  Created by Kyle Yoon on 2/14/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import Foundation

struct TripOption {
    let kind: String
    let saleTotal: String
    let identifier: String
    let slice: [TripOptionSlice]
    let pricing: [TripOptionPricing]
    
    init(kind: String,
        saleTotal: String,
        identifier: String, 
        slice: [TripOptionSlice],
        pricing: [TripOptionPricing]) {
            self.kind = kind
            self.saleTotal = saleTotal
            self.identifier = identifier
            self.slice = slice
            self.pricing = pricing
    }
}

extension TripOption {
    static func decode(jsonDict: [String: AnyObject]) -> TripOption? {
        if let kind = jsonDict["kind"] as? String,
            saleTotal = jsonDict["saleTotal"] as? String,
            identifier = jsonDict["identifier"] as? String,
            slice = jsonDict["slice"] as? [TripOptionSlice],
            pricing = jsonDict["pricing"] as? [TripOptionPricing] {
                return TripOption(kind: kind,
                    saleTotal: saleTotal,
                    identifier: identifier,
                    slice: slice,
                    pricing: pricing)
        }
        
        return nil
    }
}