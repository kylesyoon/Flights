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
    let onTimePerformance: Int?
    let operatingDisclosure: String?
    let mileage: Int
    let meal: String?
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
        mileage: Int,
        meal: String?,
        secure: Bool,
        onTimePerformance: Int?,
        operatingDisclosure: String?) {
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
    }
}

extension TripOptionSliceSegmentLeg {
    static func decode(jsonDict: [String: AnyObject]) -> TripOptionSliceSegmentLeg? {
        if let kind = jsonDict["kind"] as? String,
            identifier = jsonDict["id"] as? String,
            aircraft = jsonDict["aircraft"] as? String,
            arrivalTime = jsonDict["arrivalTime"] as? String,
            departureTime = jsonDict["departureTime"] as? String,
            origin = jsonDict["origin"] as? String,
            destination = jsonDict["destination"] as? String,
            originTerminal = jsonDict["originTerminal"] as? String,
            destinationTerminal = jsonDict["destinationTerminal"] as? String,
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
                            mileage: mileage,
                            meal: meal,
                            secure: Bool(secure),
                            onTimePerformance: onTimePerformance,
                            operatingDisclosure: operatingDisclosure)
                }
                
                return nil
        }
        return nil
    }
}