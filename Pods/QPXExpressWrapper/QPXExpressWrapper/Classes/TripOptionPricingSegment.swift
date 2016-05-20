//
//  TripOptionPricingSegment.swift
//  Flights
//
//  Created by Kyle Yoon on 3/5/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import Foundation

public struct TripOptionPricingSegment {
    
    public let kind: String
    public let fareID: String
    public let segmentID: String
    
    init(kind: String, fareID: String, segmentID: String) {
        self.kind = kind
        self.fareID = fareID
        self.segmentID = segmentID
    }
    
    static func decode(jsonDict: [String: AnyObject]) -> TripOptionPricingSegment? {
        if let kind = jsonDict["kind"] as? String,
            fareID = jsonDict["fareId"] as? String,
            segmentID = jsonDict["segmentId"] as? String {
                return TripOptionPricingSegment(kind: kind, 
                    fareID: fareID,
                    segmentID: segmentID)
        }
        
        return nil
    }
    
}

extension TripOptionPricingSegment: Equatable {}

public func ==(lhs: TripOptionPricingSegment, rhs: TripOptionPricingSegment) -> Bool {
    return lhs.kind == rhs.kind &&
        lhs.fareID == rhs.fareID &&
        lhs.segmentID == rhs.segmentID
}