//
//  TripsDataAircraft.swift
//  Flights
//
//  Created by Kyle Yoon on 3/5/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import Foundation

struct TripsDataAircraft {
    let kind: String?
    let code: String?
    let name: String?
    
    init(kind: String, code: String, name: String) {
        self.kind = kind
        self.code = code
        self.name = name
    }
    
    static func decode(jsonDict: [String: AnyObject]) -> TripsDataAircraft? {
        if let kind = jsonDict["kind"] as? String,
            code = jsonDict["code"] as? String,
            name = jsonDict["name"] as? String {
                return TripsDataAircraft(kind: kind,
                    code: code,
                    name: name)
        }
        
        return nil
    }
}

extension TripsDataAircraft: Equatable {}

func ==(lhs: TripsDataAircraft, rhs: TripsDataAircraft) -> Bool {
    return lhs.kind == rhs.kind &&
        lhs.code == rhs.code &&
        lhs.name == rhs.name
}