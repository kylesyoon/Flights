//
//  TripOptionSliceLeg.swift
//  Flights
//
//  Created by Kyle Yoon on 2/14/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import Foundation

public struct TripOptionSliceSegmentLeg {
    
    public let kind: String
    public let identifier: String
    public let aircraft: String
    public let arrivalTime: NSDate
    public let departureTime: NSDate
    public let origin: String
    public let destination: String
    public let originTerminal: String?
    public let destinationTerminal: String?
    public let duration: Int
    public let onTimePerformance: Int?
    public let operatingDisclosure: String?
    public let mileage: Int
    public let meal: String?
    public let secure: Bool
    public let connectionDuration: Int?
    
    init(kind: String,
        identifier: String,
        aircraft: String, 
        arrivalTime: NSDate,  // TODO: We have to show the local time of that location.
        departureTime: NSDate, // TODO: We have to show the local time of that location.
        origin: String,
        destination: String, 
        originTerminal: String?,
        destinationTerminal: String?,
        duration: Int,
        mileage: Int,
        meal: String?,
        secure: Bool,
        onTimePerformance: Int?,
        operatingDisclosure: String?,
        connectionDuration: Int?) {
            self.kind = kind
            self.identifier = identifier
            self.aircraft = aircraft
            self.arrivalTime = arrivalTime
            self.departureTime = departureTime
            self.origin = origin
            self.destination = destination
            self.originTerminal = originTerminal
            self.destinationTerminal = destinationTerminal
            self.duration = duration
            self.onTimePerformance = onTimePerformance
            self.operatingDisclosure = operatingDisclosure
            self.mileage = mileage
            self.meal = meal
            self.secure = secure
            self.connectionDuration = connectionDuration
    }
    
    static func decode(jsonDict: [String: AnyObject]) -> TripOptionSliceSegmentLeg? {
        if let kind = jsonDict["kind"] as? String,
            identifier = jsonDict["id"] as? String,
            aircraft = jsonDict["aircraft"] as? String,
            arrivalTime = jsonDict["arrivalTime"] as? String,
            departureTime = jsonDict["departureTime"] as? String,
            origin = jsonDict["origin"] as? String,
            destination = jsonDict["destination"] as? String,
            duration = jsonDict["duration"] as? Int,
            mileage = jsonDict["mileage"] as? Int,
            secure = jsonDict["secure"] as? Int {
            var meal: String?
            if let unwrappedMeal = jsonDict["meal"] as? String {
                meal = unwrappedMeal
            }
            
            var operatingDisclosure: String?
            if let disclosure = jsonDict["operatingDisclosure"] as? String {
                operatingDisclosure = disclosure
            }
            
            var onTimePerformance: Int?
            if let performance = jsonDict["onTimePerformance"] as? Int {
                onTimePerformance = performance
            }
            
            var destinationTerminal: String?
            if let unwrappedDestinationTerminal = jsonDict["destinationTerminal"] as? String {
                destinationTerminal = unwrappedDestinationTerminal
            }
            
            var originTerminal: String?
            if let unwrappedOriginTerminal = jsonDict["originTerminal"] as? String {
                originTerminal = unwrappedOriginTerminal
            }
            
            var connectionDuration: Int?
            if let unwrappedConnectionDuration = jsonDict["connectionDuration"] as? Int {
                connectionDuration = unwrappedConnectionDuration
            }
            
            let dateFormatter = NSDateFormatter()
            if let formattedArrivalTime = dateFormatter.decodedDate(for: arrivalTime),
                formattedDepartureTime = dateFormatter.decodedDate(for: departureTime) {
                return TripOptionSliceSegmentLeg(kind: kind,
                                                 identifier: identifier,
                                                 aircraft: aircraft,
                                                 arrivalTime: formattedArrivalTime,
                                                 departureTime: formattedDepartureTime,
                                                 origin: origin,
                                                 destination: destination,
                                                 originTerminal: originTerminal,
                                                 destinationTerminal: destinationTerminal,
                                                 duration: duration,
                                                 mileage: mileage,
                                                 meal: meal,
                                                 secure: Bool(secure),
                                                 onTimePerformance: onTimePerformance,
                                                 operatingDisclosure: operatingDisclosure,
                                                 connectionDuration: connectionDuration)
            }
            
            return nil
        }
        return nil
    }
    
}

extension TripOptionSliceSegmentLeg: Equatable {}

public func ==(lhs: TripOptionSliceSegmentLeg, rhs: TripOptionSliceSegmentLeg) -> Bool {
    return lhs.kind == rhs.kind &&
        lhs.identifier == rhs.identifier &&
        lhs.aircraft == rhs.aircraft && 
        lhs.arrivalTime.isEqualToDate(rhs.arrivalTime) && 
        lhs.departureTime.isEqualToDate(rhs.departureTime) && 
        lhs.origin == rhs.origin && 
        lhs.destination == rhs.destination && 
        lhs.originTerminal == rhs.originTerminal &&
        lhs.destinationTerminal == rhs.destinationTerminal && 
        lhs.duration == rhs.duration && 
        lhs.mileage == rhs.mileage &&
        lhs.meal == rhs.meal &&
        lhs.secure == rhs.secure &&
        lhs.onTimePerformance == rhs.onTimePerformance &&
        lhs.operatingDisclosure == rhs.operatingDisclosure &&
        lhs.connectionDuration == rhs.connectionDuration
}

// TODO: Where should this live?
extension NSDateFormatter {
    
    func decodedDate(for dateString: String) -> NSDate? {
        self.dateFormat = "yyyy-MM-dd'T'HH:mmZZZZZ" //"2016-02-19T17:35-08:00"
        return self.dateFromString(dateString)
    }
    
}
