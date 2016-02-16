//
//  TripOptionPricing.swift
//  Flights
//
//  Created by Kyle Yoon on 2/14/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import Foundation

struct TripOptionPricing {
    let kind: String
    let fare: [AnyObject]
    let segmentPricing: [AnyObject]
    let baseFareTotal: String
    let saleFareTotal: String
    let saleTotal: String
    let passengers: [String: AnyObject]
    let tax: [AnyObject]
    let fareCalculation: String
    let latestTicketingTime: NSDate
    let ptc: String
    
    init(kind: String,
        fare: [AnyObject], 
        segmentPricing: [AnyObject], 
        baseFareTotal: String, 
        saleFareTotal: String, 
        saleTotal: String, 
        passengers: [String: AnyObject], 
        tax: [AnyObject], 
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
}

extension TripOptionPricing {
    static func decode(jsonDict: NSDictionary) -> TripOptionPricing? {
        if let kind = jsonDict["kind"] as? String,
            fare = jsonDict["fare"] as? [AnyObject],
            segmentPricing = jsonDict["segmentPricing"] as? [AnyObject],
            baseFareTotal = jsonDict["baseFareTotal"] as? String,
            saleFareTotal = jsonDict["saleFareTotal"] as? String,
            saleTotal = jsonDict["saleTotal"] as? String,
            passengers = jsonDict["passengers"] as? [String: AnyObject],
            tax = jsonDict["tax"] as? [AnyObject],
            fareCalculation = jsonDict["fareCalculation"] as? String,
            latestTicketingTime = jsonDict["latestTicketingTime"] as? String,
            ptc = jsonDict["ptc"] as? String {
                if let formattedLatestTicketingTime = NSDateFormatter.decode(latestTicketingTime) {
                    return TripOptionPricing(kind: kind,
                        fare: fare,
                        segmentPricing: segmentPricing,
                        baseFareTotal: baseFareTotal,
                        saleFareTotal: saleFareTotal,
                        saleTotal: saleTotal,
                        passengers: passengers,
                        tax: tax,
                        fareCalculation: fareCalculation,
                        latestTicketingTime: formattedLatestTicketingTime,
                        ptc: ptc)
                }
                
                return nil
        }
        
        return nil
    }
}