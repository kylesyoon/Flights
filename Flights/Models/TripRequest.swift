//
//  TripRequest.swift
//  Flights
//
//  Created by Kyle Yoon on 2/22/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import Foundation
import Alamofire

struct TripRequest {

    let origin: String
    let destination: String
    let date: NSDate
    let adultPassengerCount: Int
    
    init(origin: String, destination: String, date: NSDate, adultPassengerCount: Int) {
        self.origin = origin
        self.destination = destination
        self.date = date
        self.adultPassengerCount = adultPassengerCount
    }
    
}