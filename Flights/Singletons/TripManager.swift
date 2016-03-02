//
//  TripManager.swift
//  Flights
//
//  Created by Kyle Yoon on 2/29/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import Foundation

class TripManager {
    
    static let sharedManager = TripManager()
    
    var roundTrip: Bool?
    var departureDate: NSDate?
    var returnDate: NSDate?
    var adultCount: Int?
    var departureTripOption: TripOption?
    
}
