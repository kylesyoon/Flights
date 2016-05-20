//
//  TripRequestPassengers.swift
//  Flights
//
//  Created by Kyle Yoon on 3/1/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import Foundation

public struct TripRequestPassengers {
    
    public let kind: String = "qpxexpress#passengerCounts"
    public var adultCount: Int = 1
    public let childCount: Int?
    public let infantInLapCount: Int?
    public let infantInSeatCount: Int?
    public let seniorCount: Int?
    
    public init(adultCount: Int,
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
    
    static func decode(jsonDict: [String: AnyObject]) -> TripRequestPassengers? {
        var adultCount: Int = 0
        if let decodedAdultCount = jsonDict["adultCount"] as? Int {
            adultCount = decodedAdultCount
        }
        var childCount: Int?
        if let decodedChildCount = jsonDict["childCount"] as? Int {
            childCount = decodedChildCount
        }
        var infantInLapCount: Int?
        if let decodedInfantInLapCount = jsonDict["infantInLapCount"] as? Int {
            infantInLapCount = decodedInfantInLapCount
        }
        var infantInSeatCount: Int?
        if let decodedInfantInSeatCount = jsonDict["infantInSeatCount"] as? Int {
            infantInSeatCount = decodedInfantInSeatCount
        }
        var seniorCount: Int?
        if let decodedSeniorCount = jsonDict["seniorCount"] as? Int {
            seniorCount = decodedSeniorCount
        }
        
        return TripRequestPassengers(adultCount: adultCount,
            childCount: childCount,
            infantInLapCount: infantInLapCount, 
            infantInSeatCount: infantInSeatCount,
            seniorCount: seniorCount)
    }
    
}

extension TripRequestPassengers: Equatable {}

public func ==(lhs: TripRequestPassengers, rhs: TripRequestPassengers) -> Bool {
    if lhs.adultCount != rhs.adultCount {
        return false
    }

    if lhs.childCount != rhs.adultCount {
        return false
    }
    
    if lhs.infantInLapCount != rhs.infantInLapCount {
        return false
    }
    
    if lhs.infantInSeatCount != rhs.infantInSeatCount {
        return false
    }
    
    if lhs.seniorCount != rhs.seniorCount {
        return false
    }
    
    return true
}
