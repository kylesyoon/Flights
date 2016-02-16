//
//  TripOptionSliceLeg.swift
//  Flights
//
//  Created by Kyle Yoon on 2/14/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import Foundation

struct TripOptionSliceSegmentLeg {
    let kind: String
    let identifier: String
    let aircraft: String
    let arrivalTime: NSDate
    let departureTime: NSDate
    let origin: String
    let destination: String
    let originTerminal: String
    let destinationTerminal: String
    let duration: Int
    let onTimePerformance: Int
    let mileage: Int
    let meal: String
    let secure: Bool
    
    init(kind: String,
        identifier: String,
        aircraft: String, 
        arrivalTime: NSDate, 
        departureTime: NSDate, 
        origin: String,
        destination: String, 
        originTerminal: String, 
        destinationTerminal: String, 
        duration: Int, 
        onTimePerformance: Int, 
        mileage: Int,
        meal: String,
        secure: Bool) {
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
            self.mileage = mileage
            self.meal = meal
            self.secure = secure
    }
}

extension TripOptionSliceSegmentLeg {
    static func decode(jsonDict: NSDictionary) -> TripOptionSliceSegmentLeg? {
        if let kind = jsonDict["kind"] as? String,
            identifier = jsonDict["identifier"] as? String,
            aircraft = jsonDict["aircraft"] as? String,
            arrivalTime = jsonDict["arrivalTime"] as? String,
            departureTime = jsonDict["departureTime"] as? String,
            origin = jsonDict["origin"] as? String,
            destination = jsonDict["destination"] as? String,
            originTerminal = jsonDict["originTerminal"] as? String,
            destinationTerminal = jsonDict["destinationTerminal"] as? String,
            duration = jsonDict["duration"] as? Int,
            onTimePerformance = jsonDict["onTimePerformance"] as? Int,
            mileage = jsonDict["mileage"] as? Int,
            meal = jsonDict["meal"] as? String,
            secure = jsonDict["secure"] as? Bool {
                if let formattedArrivalTime = NSDateFormatter.decode(arrivalTime),
                    formattedDepartureTime = NSDateFormatter.decode(departureTime) {
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
                            onTimePerformance: onTimePerformance,
                            mileage: mileage,
                            meal: meal,
                            secure: secure)
                }
                
                return nil
        }
        return nil
    }
}