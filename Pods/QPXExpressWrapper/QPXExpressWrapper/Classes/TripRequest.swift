//
//  TripRequest.swift
//  Flights
//
//  Created by Kyle Yoon on 2/22/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import Foundation

public struct TripRequest {

    public let passengers: TripRequestPassengers
    public let slice: [TripRequestSlice]
    public let maxPrice: String?
    public let saleCountry: String?
    public let refundable: Bool?
    public let solutions: Int?
    
    public init(passengers: TripRequestPassengers,
                slice: [TripRequestSlice],
                maxPrice: String?,
                saleCountry: String?,
                refundable: Bool?,
                solutions: Int?) {
            self.passengers = passengers
            self.slice = slice
            self.maxPrice = maxPrice
            self.saleCountry = saleCountry
            self.refundable = refundable
            self.solutions = solutions
    }
    
    public func jsonDict() -> [String: AnyObject] {
        var jsonDict = ["passengers": self.passengers.jsonDict()].mutableCopy() as! [String: AnyObject]
        let slicesJSONArray = self.slice.map { slice in slice.jsonDict() }
        jsonDict["slice"] = slicesJSONArray
        
        if let maxPrice = self.maxPrice {
            jsonDict["maxPrice"] = maxPrice
        }
        
        if let saleCountry = self.saleCountry {
            jsonDict["saleCountry"] = saleCountry
        }
        
        if let refundable = self.refundable {
            jsonDict["refundable"] = refundable
        }
        
        if let solutions = self.solutions {
            jsonDict["solution"] = solutions
        }

        return ["request": jsonDict]
    }
    
}