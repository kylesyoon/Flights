//
//  TripRequestPassengers.swift
//  Flights
//
//  Created by Kyle Yoon on 3/1/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import Foundation

struct TripRequestPassengers {
    
    let kind: String = "qpxexpress#passengerCounts"
    var adultCount: Int = 1
    let childCount: Int?
    let infantInLapCount: Int?
    let infantInSeatCount: Int?
    let seniorCount: Int?
    
    init(adultCount: Int, // There has to be an adult no matter what right?
        childCount: Int?,
        infantInLapCount: Int?, 
        infantInSeatCount: Int?,
        seniorCount: Int?) {
            self.adultCount = adultCount
            self.childCount = childCount
            self.infantInLapCount = infantInLapCount
            self.infantInSeatCount = infantInSeatCount
            self.seniorCount = seniorCount
    }
    
    func jsonDict() -> [String: AnyObject] {
        var jsonDict = ["kind": self.kind, "adultCount": self.adultCount].mutableCopy() as! [String: AnyObject]
        if let childCount = self.childCount {
            jsonDict["childCount"] = childCount
        }
        if let infantInLapCount = self.infantInLapCount {
            jsonDict["infantInLapCount"] = infantInLapCount
        }
        if let infantInSeatCount = self.infantInSeatCount {
            jsonDict["infantInSeatCount"] = infantInSeatCount
        }
        if let seniorCount = self.seniorCount {
            jsonDict["seniorCount"] = seniorCount
        }
        return jsonDict
    }
    
}