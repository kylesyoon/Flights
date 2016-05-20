//
//  TripsData.swift
//  Flights
//
//  Created by Kyle Yoon on 2/14/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import Foundation

public struct TripsData {
    
    public let kind: String
    public let airport: [TripsDataAirport]
    public let city: [TripsDataCity]
    public let aircraft: [TripsDataAircraft]
    public let tax: [TripsDataTax]
    public let carrier: [TripsDataCarrier]
    
    init(kind: String,
        airport: [TripsDataAirport],
        city: [TripsDataCity],
        aircraft: [TripsDataAircraft],
        tax: [TripsDataTax],
        carrier: [TripsDataCarrier]) {
            self.kind = kind
            self.airport = airport
            self.city = city
            self.aircraft = aircraft
            self.tax = tax
            self.carrier = carrier
    }
    
    static func decode(jsonDict: NSDictionary) -> TripsData? {
        if let kind = jsonDict["kind"] as? String,
            airport = jsonDict["airport"] as? [[String: AnyObject]],
            city = jsonDict["city"] as? [[String: AnyObject]],
            aircraft = jsonDict["aircraft"] as? [[String: AnyObject]],
            tax = jsonDict["tax"] as? [[String: AnyObject]],
            carrier = jsonDict["carrier"] as? [[String: AnyObject]] {
            var decodedAirports = [TripsDataAirport]()
            for anAirport in airport {
                if let decodedAirport = TripsDataAirport.decode(anAirport) {
                    decodedAirports.append(decodedAirport)
                }
            }
            var decodedCities = [TripsDataCity]()
            for aCity in city {
                if let decodedCity = TripsDataCity.decode(aCity) {
                    decodedCities.append(decodedCity)
                }
            }
            var decodedAircrafts = [TripsDataAircraft]()
            for anAircraft in aircraft {
                if let decodedAircraft = TripsDataAircraft.decode(anAircraft) {
                    decodedAircrafts.append(decodedAircraft)
                }
            }
            var decodedTaxes = [TripsDataTax]()
            for aTax in tax {
                if let decodedTax = TripsDataTax.decode(aTax) {
                    decodedTaxes.append(decodedTax)
                }
            }
            var decodedCarriers = [TripsDataCarrier]()
            for aCarrier in carrier {
                if let decodedCarrier = TripsDataCarrier.decode(aCarrier) {
                    decodedCarriers.append(decodedCarrier)
                }
            }
            
            return TripsData(kind: kind,
                             airport: decodedAirports,
                             city: decodedCities,
                             aircraft: decodedAircrafts,
                             tax: decodedTaxes,
                             carrier: decodedCarriers)
        }
        
        return nil
    }
    
}

extension TripsData: Equatable {}

public func ==(lhs: TripsData, rhs: TripsData) -> Bool {
    return lhs.kind == rhs.kind && lhs.airport == rhs.airport && lhs.city == rhs.city && lhs.aircraft == rhs.aircraft && lhs.tax == rhs.tax && lhs.carrier == rhs.carrier
}