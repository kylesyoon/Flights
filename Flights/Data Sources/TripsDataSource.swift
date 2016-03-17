//
//  TripsDataSource.swift
//  Flights
//
//  Created by Kyle Yoon on 2/29/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

//TODO: Implement datasource that gets results holding both departure and return.
import Foundation

typealias TripCellData = (tripOption: TripOption, airlineNames: [String], sliceIndex: Int)

class TripsDataSource {
    
    private let departureSliceIndex = 0;
    private let returnSliceIndex = 1;
    
    var searchResults: SearchResults
    var tripCellDataToDisplay: [[TripCellData]] = []
    var tripOptionsToDisplay: [[TripOption]] = []
    var isSelectingDepature = true {
        didSet {
            currentSliceIndex = isSelectingDepature ? 0 : 1
        }
    }
    private(set) var currentSliceIndex = 0
    
    init(searchResults: SearchResults) {
        self.searchResults = searchResults
        self.tripCellDataToDisplay = self.uniqueTripCellDataForDeparture()
    }
    
    func tripCellDataForIndexPath(indexPath: NSIndexPath) -> TripCellData {
        return self.tripCellDataToDisplay[indexPath.section][indexPath.row]
    }

    func numberOfRowsForSection(section: Int) -> Int {
        return tripCellDataToDisplay[section].count
    }
    
    func numberOfSections() -> Int {
        return tripCellDataToDisplay.count
    }
    
    func selectedTripOptionAtIndexPath(indexPath: NSIndexPath) {
        let selectedTripCellData = self.tripCellDataToDisplay[indexPath.section][indexPath.row]
        let sameDepartureTripOptions = self.searchResults.trips.tripOptions.filter { $0.slice[0] == selectedTripCellData.tripOption.slice[0] }
        let departureTripCellData = sameDepartureTripOptions.map { TripCellData($0, self.fullCarrierNamesTripOption($0), self.currentSliceIndex) }
        self.tripCellDataToDisplay = [[selectedTripCellData], departureTripCellData]
    }
    
    /**
     Filters trip options with redundant slice[0]s (departure slice) and makes a sectioned array of TripCellData tuples.

     - returns: A sectioned array of TripCellData
     */
    private func uniqueTripCellDataForDeparture() -> [[TripCellData]] {
        var tripCellDataToDisplay = [TripCellData]()
        for tripOption in self.searchResults.trips.tripOptions {
            let duplicateTripOptions = tripCellDataToDisplay.filter { $0.tripOption.slice[0] == tripOption.slice[0] }
            if duplicateTripOptions.isEmpty {
                let carrierNames = self.fullCarrierNamesTripOption(tripOption)
                tripCellDataToDisplay.append(TripCellData(tripOption, carrierNames, 0))
            }
        }
        
        return [tripCellDataToDisplay]
    }
    
    /**
     Get's the carrier code from the trip option and finds the airline name in the search results trip data.
     
     - parameter tripOption: The trip option with carrier codes of interest
     
     - returns: The carrier names
     */
    private func fullCarrierNamesTripOption(tripOption: TripOption) -> [String] {
        let airlineCarrierCodes = tripOption.slice[self.currentSliceIndex].segment.map { $0.flight.carrier }
        var carriers = [TripsDataCarrier]()
        for code in airlineCarrierCodes {
            carriers.appendContentsOf(self.searchResults.trips.data.carrier.filter { $0.code == code })
        }
        var uniqueCarrierNames = [String]()
        for carrier in carriers {
            if !uniqueCarrierNames.contains(carrier.name) {
                uniqueCarrierNames.append(carrier.name)
            }
        }
        
        return uniqueCarrierNames
    }
    
}