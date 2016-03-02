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
    
    static func presentableDate(fromDate date: NSDate) -> String {
        self.dateFormatter.dateFormat = "MMM'.' dd',' yy"
        return self.dateFormatter.stringFromDate(date)
    }
    
    static func presentableTime(fromDate date: NSDate) -> String {
        let usTwelveHourLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        self.dateFormatter.locale = usTwelveHourLocale // Investigate what this locale does
        self.dateFormatter.dateFormat = "hh':'mm a"
        return self.dateFormatter.stringFromDate(date)
    }
    
}