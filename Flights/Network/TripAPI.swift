//
//  TripAPI.swift
//  Flights
//
//  Created by Yoon, Kyle on 2/12/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import Foundation
import QPXExpressWrapper

typealias TripAPISuccessCompletion = (SearchResults) -> Void
typealias TripAPIFailureCompletion = (ErrorType) -> Void

struct TripAPI {
    
    static let baseURL = "https://www.googleapis.com/qpxExpress/v1/trips/search"
    static let maxSolutions = 3
    
    static func searchTripsWithRequest(tripRequest: TripRequest,
        success: TripAPISuccessCompletion,
        failure: TripAPIFailureCompletion) {
            let tripsURLComponents = NSURLComponents(string: baseURL)
            let keyQueryItem = NSURLQueryItem(name: "key", value: Keys.APIKey)
            tripsURLComponents?.queryItems = [keyQueryItem]
            
            if let tripsURL = tripsURLComponents?.URL {
                APIUtility.SharedUtility.postJSON(tripsURL.absoluteString,
                    parameters: tripRequest.jsonDict(),
                    success: {
                        dict in
                        if let searchResults = SearchResults.decode(dict) {
                            success(searchResults)
                        } else {
                            // Decoding error
                        }
                    }, failure: failure)
            }
    }

}