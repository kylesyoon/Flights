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
            identifier = jsonDict["id"] as? String,
            slice = jsonDict["slice"] as? [[String: AnyObject]],
            pricing = jsonDict["pricing"] as? [[String: AnyObject]] {
                var decodedSlices = [TripOptionSlice]()
                for aSlice in slice {
                    if let decodedSlice = TripOptionSlice.decode(aSlice) {
                        decodedSlices.append(decodedSlice)
                    }
                }
                var decodedPricings = [TripOptionPricing]()
                for aPricing in pricing {
                    if let decodedPricing = TripOptionPricing.decode(aPricing) {
                        decodedPricings.append(decodedPricing)
                    }
                }
                
                return TripOption(kind: kind,
                    saleTotal: saleTotal,
                    identifier: identifier,
                    slice: decodedSlices,
                    pricing: decodedPricings)
        }
        
        return nil
    }
}

extension TripOption: Equatable {}

func ==(lhs: TripOption, rhs: TripOption) -> Bool {
    return lhs.kind == rhs.kind &&
        lhs.saleTotal == rhs.saleTotal &&
        lhs.identifier == rhs.identifier && 
        lhs.slice == rhs.slice &&
        lhs.pricing == rhs.pricing
}