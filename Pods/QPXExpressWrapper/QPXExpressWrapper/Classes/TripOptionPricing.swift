//
//  TripOptionPricing.swift
//  Flights
//
//  Created by Kyle Yoon on 2/14/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import Foundation

public struct TripOptionPricing {
    
    public let kind: String
    public let fare: [TripOptionPricingFare]
    public let segmentPricing: [TripOptionPricingSegment]
    public let baseFareTotal: String
    public let saleFareTotal: String
    public let saleTotal: String
    public let passengers: TripRequestPassengers
    public let tax: [TripOptionPricingTax]
    public let fareCalculation: String
    public let latestTicketingTime: NSDate
    public let ptc: String
    
    init(kind: String,
        fare: [TripOptionPricingFare],
        segmentPricing: [TripOptionPricingSegment],
        baseFareTotal: String, 
        saleFareTotal: String, 
        saleTotal: String, 
        passengers: TripRequestPassengers,
        tax: [TripOptionPricingTax],
        fareCalculation: String, 
        latestTicketingTime: NSDate,
        ptc: String) {
            self.kind = kind
            self.fare = fare
            self.segmentPricing = segmentPricing
            self.baseFareTotal = baseFareTotal
            self.saleFareTotal = saleFareTotal
            self.saleTotal = saleTotal
            self.passengers = passengers
            self.tax = tax
            self.fareCalculation = fareCalculation
            self.latestTicketingTime = latestTicketingTime
            self.ptc = ptc
    }
    
    static func decode(jsonDict: [String: AnyObject]) -> TripOptionPricing? {
        if let kind = jsonDict["kind"] as? String,
            fare = jsonDict["fare"] as? [[String: AnyObject]],
            segmentPricing = jsonDict["segmentPricing"] as? [[String: AnyObject]],
            baseFareTotal = jsonDict["baseFareTotal"] as? String,
            saleFareTotal = jsonDict["saleFareTotal"] as? String,
            saleTotal = jsonDict["saleTotal"] as? String,
            passengers = jsonDict["passengers"] as? [String: AnyObject],
            tax = jsonDict["tax"] as? [[String: AnyObject]],
            fareCalculation = jsonDict["fareCalculation"] as? String,
            latestTicketingTime = jsonDict["latestTicketingTime"] as? String,
            ptc = jsonDict["ptc"] as? String {
            var decodedFares = [TripOptionPricingFare]()
            for jsonFare in fare {
                if let decodedFare = TripOptionPricingFare.decode(jsonFare) {
                    decodedFares.append(decodedFare)
                }
            }
            var decodedSegments = [TripOptionPricingSegment]()
            for jsonSegment in segmentPricing {
                if let decodedSegment = TripOptionPricingSegment.decode(jsonSegment) {
                    decodedSegments.append(decodedSegment)
                }
            }
            var decodedTaxes = [TripOptionPricingTax]()
            for jsonTax in tax {
                if let decodedTax = TripOptionPricingTax.decode(jsonTax) {
                    decodedTaxes.append(decodedTax)
                }
            }
            let dateFormatter = NSDateFormatter()
            if let formattedLatestTicketingTime = dateFormatter.decodedDate(for: latestTicketingTime),
                decodedPassengers = TripRequestPassengers.decode(passengers) {
                return TripOptionPricing(kind: kind,
                                         fare: decodedFares,
                                         segmentPricing: decodedSegments,
                                         baseFareTotal: baseFareTotal,
                                         saleFareTotal: saleFareTotal,
                                         saleTotal: saleTotal,
                                         passengers: decodedPassengers,
                                         tax: decodedTaxes,
                                         fareCalculation: fareCalculation,
                                         latestTicketingTime: formattedLatestTicketingTime,
                                         ptc: ptc)
            }
            
            return nil
        }
        
        return nil
    }

}

extension TripOptionPricing: Equatable {}

public func ==(lhs: TripOptionPricing, rhs: TripOptionPricing) -> Bool {
    return lhs.kind == rhs.kind &&
        lhs.fare == rhs.fare && 
        lhs.segmentPricing == rhs.segmentPricing &&
        lhs.baseFareTotal == rhs.baseFareTotal && 
        lhs.saleFareTotal == rhs.saleFareTotal && 
        lhs.saleTotal == rhs.saleTotal &&
        lhs.passengers == rhs.passengers &&
        lhs.tax == rhs.tax && 
        lhs.fareCalculation == rhs.fareCalculation &&
        lhs.latestTicketingTime == rhs.latestTicketingTime &&
        lhs.ptc == rhs.ptc
}
