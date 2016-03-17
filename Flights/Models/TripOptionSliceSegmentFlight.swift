//
//  Flight.swift
//  Flights
//
//  Created by Kyle Yoon on 2/14/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import Foundation

struct TripOptionSliceSegmentFlight {
    let carrier: String
    let number: String
    
    init(number: String, carrier: String) {
        self.number = number
        self.carrier = carrier
    }
}

extension TripOptionSliceSegmentFlight {
    static func decode(jsonDict: [String: AnyObject]) -> TripOptionSliceSegmentFlight? {
        if let number = jsonDict["number"] as? String,
            carrier = jsonDict["carrier"] as? String {
                return TripOptionSliceSegmentFlight(number: number, carrier: carrier)
        }
        
        return nil
    }
}

extension TripOptionSliceSegmentFlight: Equatable {}

func ==(lhs: TripOptionSliceSegmentFlight, rhs: TripOptionSliceSegmentFlight) -> Bool {
    return lhs.carrier == rhs.carrier &&
        lhs.number == rhs.number
}
