//
//  SearchData.swift
//  Flights
//
//  Created by Kyle Yoon on 2/14/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import Foundation

public struct SearchResults {
    
    public let kind: String
    public let trips: Trips
    
    // Only setable within this class
    private(set) public var isRoundTrip: Bool = true
    
    init(kind: String, trips: Trips) {
        self.kind = kind
        self.trips = trips
    }
    
    public static func decode(jsonDict: [String: AnyObject]) -> SearchResults? {
        if let kind = jsonDict["kind"] as? String,
            trips = jsonDict["trips"] as? [String: AnyObject] {
            if let trips = Trips.decode(trips) {
                var searchResults = SearchResults(kind: kind, trips: trips)
                
                // Checking if the trip options have a return flight slice
                let tripOptionsWithReturnFlights = trips.tripOptions.filter { $0.slice.count > 1 }
                if tripOptionsWithReturnFlights.isEmpty {
                    searchResults.isRoundTrip = false
                }
                
                return searchResults
            }

            return nil
        }
        
        return nil
    }
    
}

extension SearchResults: Equatable {}

public func ==(lhs: SearchResults, rhs: SearchResults) -> Bool {
    return lhs.kind == rhs.kind && lhs.trips == rhs.trips
}