//
//  TripAPI.swift
//  Flights
//
//  Created by Yoon, Kyle on 2/12/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import Foundation

typealias TripAPISuccessCompletion = ([String: AnyObject]) -> Void
typealias TripAPIFailureCompletion = (ErrorType) -> Void

struct TripAPI {
    
    static let baseURL = "https://www.googleapis.com/qpxExpress/v1/trips/search"
    static let maxSolutions = 20
    
    static func searchTripsFromOrigin(origin: String,
        toDestination destination: String,
        onDate date: NSDate, 
        withNumberOfPassengers passengers: Int, 
        success: TripAPISuccessCompletion,
        failure: TripAPIFailureCompletion) {
            let tripsURLComponents = NSURLComponents(string: baseURL)
            let keyQueryItem = NSURLQueryItem(name: "key", value: Keys.APIKey)
            tripsURLComponents?.queryItems = [keyQueryItem]
            
            if let tripsURL = tripsURLComponents?.URL {
                APIUtility.SharedUtility.postJSON(tripsURL.absoluteString,
                    parameters: self.searchParameters(origin,
                        destination: destination,
                        date: date,
                        passengers: passengers),
                    success: success,
                    failure: failure)
            }
    }
    
    private static func searchParameters(origin: String,
        destination: String,
        date: NSDate, 
        passengers: Int) -> [String: AnyObject] {
            let tripDateComponents = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: date)
            let dateString = "\(tripDateComponents.year)-\(tripDateComponents.month)-\(tripDateComponents.day)"
            
            let searchParameters = ["request": ["slice": [["origin": origin, "destination": destination, "date": dateString]], "passengers": ["adultCount": passengers, "infantInLapCount": 0, "infantInSeatCount": 0, "childCount": 0, "seniorCount": 0], "solutions": self.maxSolutions, "refundable": false]]
            
            return searchParameters
    }
    
}