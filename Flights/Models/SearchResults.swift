//
//  SearchData.swift
//  Flights
//
//  Created by Kyle Yoon on 2/14/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import Foundation

struct SearchResults {
    let kind: String
    let trips: Trips
    
    init(kind: String, trips: Trips) {
        self.kind = kind
        self.trips = trips
    }
    
}

extension SearchResults {
    static func decode(jsonDict: NSDictionary) -> SearchResults? {
        if let kind = jsonDict["kind"] as? String,
            trips = jsonDict["trips"] as? [String: AnyObject] {
                if let trips = Trips.decode(trips) {
                    return SearchResults(kind: kind, trips: trips)
                }
                
                return nil
        }
        
        return nil
    }
}

extension SearchResults: Equatable {}

func ==(lhs: SearchResults, rhs: SearchResults) -> Bool {
    return lhs.kind == rhs.kind && lhs.trips == rhs.trips
}