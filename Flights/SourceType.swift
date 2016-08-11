//
//  SourceType.swift
//  Flights
//
//  Created by Kyle Yoon on 8/2/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import Foundation
import QPXExpressWrapper

protocol SourceType {
}

struct SourceFlight: SourceType {
    
    let tripOption: TripOption
    let airlineNames: [String]
    let sliceIndex: Int
    
}
