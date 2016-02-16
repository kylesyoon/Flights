//
//  Trips.swift
//  Flights
//
//  Created by Kyle Yoon on 2/14/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import Foundation

struct Trips {
    let kind: String
    let requestID: String
    let data: TripsData
    let tripOption: [TripOption]
    
    init(kind: String,
        requestID: String, 
        data: TripsData,
        tripOption: [TripOption]) {
            self.kind = kind
            self.requestID = requestID
            self.data = data
            self.tripOption = tripOption
    }
}

extension Trips {
    static func decode(jsonDict: [String: AnyObject]) -> Trips? {
        if let kind = jsonDict["kind"] as? String,
            requestID = jsonDict["requestId"] as? String,
            data = jsonDict["data"] as? [String: AnyObject],
            tripOption = jsonDict ["tripOption"] as? [[String: AnyObject]] {
                var decodedTripOptions = [TripOption]()
                for option in tripOption {
                    if let decodedOption = TripOption.decode(option) {
                        decodedTripOptions.append(decodedOption)
                    }
                }
                
                if let data = TripsData.decode(data) {
                    return Trips(kind: kind,
                        requestID: requestID,
                        data: data,
                        tripOption: decodedTripOptions)
                }
        }
        
        return nil
    }
}