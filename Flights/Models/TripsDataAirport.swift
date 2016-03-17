//
//  TripsDataAirport.swift
//  Flights
//
//  Created by Kyle Yoon on 3/5/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import Foundation

struct TripsDataAirport {
    let kind: String
    let code: String
    let city: String
    let name: String
    
    init(kind: String, code: String, city: String, name: String) {
        self.kind = kind
        self.code = code
        self.city = city
        self.name = name
    }
    
    //TODO: decode
    static func decode(jsonDict: [String: AnyObject]) -> TripsDataAirport? {
        if let kind = jsonDict["kind"] as? String,
            code = jsonDict["code"] as? String,
            city = jsonDict["city"] as? String,
            name = jsonDict["name"] as? String {
                return TripsDataAirport(kind: kind,
                    code: code, 
                    city: city, 
                    name: name)
        }
        
        return nil
    }
}

//TODO: Equatable protocol

extension TripsDataAirport: Equatable {}

func ==(lhs: TripsDataAirport, rhs: TripsDataAirport) -> Bool {
    return lhs.kind == rhs.kind &&
        lhs.code == rhs.code &&
        lhs.city == rhs.city &&
        lhs.name == rhs.name
}