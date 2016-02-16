//
//  TripOptionSlice.swift
//  Flights
//
//  Created by Kyle Yoon on 2/14/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import Foundation

struct TripOptionSlice {
    let kind: String
    let duration: Int
    let segment: [TripOptionSliceSegment]
    
    init(kind: String,
        duration: Int,
        segment: [TripOptionSliceSegment]) {
            self.kind = kind
            self.duration = duration
            self.segment = segment
    }
}

extension TripOptionSlice {
    static func decode(jsonDict: NSDictionary) -> TripOptionSlice? {
        if let kind = jsonDict["kind"] as? String,
            duration = jsonDict["duration"] as? Int,
            segment = jsonDict["segment"] as? [TripOptionSliceSegment]{
            return TripOptionSlice(kind: kind,
                duration: duration,
                segment: segment)
        }
        
        return nil
    }
}