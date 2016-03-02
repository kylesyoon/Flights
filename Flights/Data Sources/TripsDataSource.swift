//
//  TripsDataSource.swift
//  Flights
//
//  Created by Kyle Yoon on 2/29/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

//TODO: Implement datasource that gets results holding both departure and return.
import Foundation

class TripsDataSource {
    
    var departureSearchResults: SearchResults
    var selectedDepartureTripOption: TripOption?
    var returnSearchResults: SearchResults?
    var allTripOptions: [[TripOption]] = []
    
    init(searchResults: SearchResults) {
        self.departureSearchResults = searchResults
        self.allTripOptions = [searchResults.trips.tripOption]
    }
    
    func mergeReturnTripSearchResults(searchResults: SearchResults) {
        self.returnSearchResults = searchResults
    }
    
    func selectedTripOptionAtIndexPath(indexPath: NSIndexPath) {
        self.selectedDepartureTripOption = self.allTripOptions[indexPath.section][indexPath.row]
        if let selectedDepartureTripOption = self.selectedDepartureTripOption {
            if let returnSearchResults = self.returnSearchResults {
                self.allTripOptions = [[selectedDepartureTripOption], returnSearchResults.trips.tripOption]
            }
        }
    }
    
    func tripOptionForIndexPath(indexPath: NSIndexPath) -> TripOption {
        return self.allTripOptions[indexPath.section][indexPath.row]
    }
    
    func numberOfRowsForSection(section: Int) -> Int {
        return self.allTripOptions[section].count
    }
    
    func numberOfSections() -> Int {
        return self.allTripOptions.count
    }
    
}