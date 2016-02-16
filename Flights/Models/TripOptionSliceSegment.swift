//
//  TripOptionSliceSegment.swift
//  Flights
//
//  Created by Kyle Yoon on 2/14/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import Foundation

struct TripOptionSliceSegment {
    let kind: String
    let duration: Int
    let flight: Flight
    let identifier: String
    let cabin: String
    let bookingCode: String
    let bookingCodeCount: Int
    let marriedSegmentGroup: String
    let leg: [TripOptionSliceSegmentLeg]
    
    init(kind: String,
        duration: Int,
        flight: Flight,
        identifier: String,
        cabin: String,
        bookingCode: String,
        bookingCodeCount: Int,
        marriedSegmentGroup: String,
        leg: [TripOptionSliceSegmentLeg]) {
            self.kind = kind
            self.duration = duration
            self.flight = flight
            self.identifier = identifier
            self.cabin = cabin
            self.bookingCode = bookingCode
            self.bookingCodeCount = bookingCodeCount
            self.marriedSegmentGroup = marriedSegmentGroup
            self.leg = leg
    }
}

extension TripOptionSliceSegment {
    static func decode(jsonDict: NSDictionary) -> TripOptionSliceSegment? {
        if let kind = jsonDict["kind"] as? String,
            duration = jsonDict["duration"] as? Int, 
            flight = jsonDict["flight"] as? [String: AnyObject], 
            identifier = jsonDict["identifier"] as? String, 
            cabin = jsonDict["cabin"] as? String, 
            bookingCode = jsonDict["bookingCode"] as? String, 
            bookingCodeCount = jsonDict["bookingCodeCount"] as? Int,
            marriedSegmentGroup = jsonDict["marriedSegmentGroup"] as? String,
            leg = jsonDict["leg"] as? [TripOptionSliceSegmentLeg] {
                if let decodedFlight = Flight.decode(flight) {
                    return TripOptionSliceSegment(kind: kind,
                        duration: duration,
                        flight: decodedFlight,
                        identifier: identifier,
                        cabin: cabin,
                        bookingCode: bookingCode,
                        bookingCodeCount: bookingCodeCount,
                        marriedSegmentGroup: marriedSegmentGroup,
                        leg: leg)
                }

        }
        
        return nil
    }
}