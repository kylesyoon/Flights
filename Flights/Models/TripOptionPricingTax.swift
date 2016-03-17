//
//  TripOptionPricingTax.swift
//  Flights
//
//  Created by Kyle Yoon on 3/5/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import Foundation

struct TripOptionPricingTax {
    let kind: String
    let identifier: String
    let chargeType: String
    let code: String
    let country: String
    let salePrice: String
    
    init(kind: String, 
        identifier: String, 
        chargeType: String, 
        code: String, 
        country: String, 
        salePrice: String) {
            self.kind = kind
            self.identifier = identifier
            self.chargeType = chargeType
            self.code = code
            self.country = country
            self.salePrice = salePrice
    }
    
    static func decode(jsonDict: [String: AnyObject]) -> TripOptionPricingTax? {
        if let kind = jsonDict["kind"] as? String, 
            identifier = jsonDict["id"] as? String, 
            chargeType = jsonDict["chargeType"] as? String, 
            code = jsonDict["code"] as? String, 
            country = jsonDict["country"] as? String,
            salePrice = jsonDict["salePrice"] as? String {
                return TripOptionPricingTax(kind: kind, 
                    identifier: identifier, 
                    chargeType: chargeType,
                    code: code, 
                    country: country,
                    salePrice: salePrice)
        }
        
        return nil
    }
}

extension TripOptionPricingTax: Equatable {}

func ==(lhs: TripOptionPricingTax, rhs: TripOptionPricingTax) -> Bool {
    return lhs.kind == rhs.kind &&
        lhs.identifier == rhs.identifier &&
        lhs.chargeType == rhs.chargeType &&
        lhs.code == rhs.code &&
        lhs.country == rhs.country &&
        lhs.salePrice == rhs.salePrice
}
