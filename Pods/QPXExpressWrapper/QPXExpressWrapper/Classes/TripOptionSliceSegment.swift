//
//  TripOptionSliceSegment.swift
//  Flights
//
//  Created by Kyle Yoon on 2/14/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import Foundation

public struct TripOptionSliceSegment {
    
    public let kind: String
    public let duration: Int
    public let flight: TripOptionSliceSegmentFlight
    public let identifier: String
    public let cabin: String
    public let bookingCode: String
    public let bookingCodeCount: Int
    public let marriedSegmentGroup: String
    public let leg: [TripOptionSliceSegmentLeg]
    public let connectionDuration: Int?
    
    init(kind: String,
        duration: Int,
        flight: TripOptionSliceSegmentFlight,
        identifier: String,
        cabin: String,
        bookingCode: String,
        bookingCodeCount: Int,
        marriedSegmentGroup: String,
        leg: [TripOptionSliceSegmentLeg],
        connectionDuration: Int?) {
            self.kind = kind
            self.duration = duration
            self.flight = flight
            self.identifier = identifier
            self.cabin = cabin
            self.bookingCode = bookingCode
            self.bookingCodeCount = bookingCodeCount
            self.marriedSegmentGroup = marriedSegmentGroup
            self.leg = leg
            self.connectionDuration = connectionDuration
    }
    
    static func decode(jsonDict: [String: AnyObject]) -> TripOptionSliceSegment? {
        if let kind = jsonDict["kind"] as? String,
            duration = jsonDict["duration"] as? Int,
            flight = jsonDict["flight"] as? [String: AnyObject],
            identifier = jsonDict["id"] as? String,
            cabin = jsonDict["cabin"] as? String,
            bookingCode = jsonDict["bookingCode"] as? String,
            bookingCodeCount = jsonDict["bookingCodeCount"] as? Int,
            marriedSegmentGroup = jsonDict["marriedSegmentGroup"] as? String,
            leg = jsonDict["leg"] as? [[String: AnyObject]] {
            var decodedLegs = [TripOptionSliceSegmentLeg]()
            for aLeg in leg {
                if let decodedLeg = TripOptionSliceSegmentLeg.decode(aLeg) {
                    decodedLegs.append(decodedLeg)
                }
            }
            
            var connectionDuration: Int?
            if let unwrappedConnectionDuration = jsonDict["connectionDuration"] as? Int {
                connectionDuration = unwrappedConnectionDuration
            }
            
            if let decodedFlight = TripOptionSliceSegmentFlight.decode(flight) {
                return TripOptionSliceSegment(kind: kind,
                                              duration: duration,
                                              flight: decodedFlight,
                                              identifier: identifier,
                                              cabin: cabin,
                                              bookingCode: bookingCode,
                                              bookingCodeCount: bookingCodeCount,
                                              marriedSegmentGroup: marriedSegmentGroup,
                                              leg: decodedLegs,
                                              connectionDuration: connectionDuration)
            }
        }
        
        return nil
    }
    
}

extension TripOptionSliceSegment: Equatable {}

public func ==(lhs: TripOptionSliceSegment, rhs: TripOptionSliceSegment) -> Bool {
    return lhs.kind == rhs.kind &&
        lhs.duration == rhs.duration &&
        lhs.flight == rhs.flight &&
        lhs.identifier == rhs.identifier &&
        lhs.cabin == rhs.cabin &&
        lhs.bookingCode == rhs.bookingCode &&
        lhs.bookingCodeCount == rhs.bookingCodeCount &&
        lhs.marriedSegmentGroup == rhs.marriedSegmentGroup &&
        lhs.leg == rhs.leg &&
        lhs.connectionDuration == rhs.connectionDuration
}
