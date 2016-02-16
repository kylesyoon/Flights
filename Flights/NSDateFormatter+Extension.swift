//
//  NSDateFormatter+Extension.swift
//  Flights
//
//  Created by Kyle Yoon on 2/14/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import Foundation

extension NSDateFormatter {
    
    private static let dateFormatter = NSDateFormatter()
    
    static func decode(dateString: String) -> NSDate? {
        self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mmZZZZZ" //"2016-02-19T17:35-08:00"
        return self.dateFormatter.dateFromString(dateString)
    }
    
}