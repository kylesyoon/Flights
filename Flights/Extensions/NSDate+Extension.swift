//
//  NSDate+Extension.swift
//  Flights
//
//  Created by Kyle Yoon on 3/5/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import Foundation

extension NSDate {
    func equalToDate(date: NSDate) -> Bool {
        return self.compare(date) == .OrderedSame
    }
}