//
//  TypeaheadDataSource.swift
//  Flights
//
//  Created by Kyle Yoon on 3/10/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import Foundation

class TypeaheadDataSource {

    let airports: [String] = try! NSJSONSerialization.JSONObjectWithData(NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("airports", ofType: "json")!, options: .DataReadingMappedIfSafe), options: []) as! [String]
    var typeaheadResults = [String]()
    
    func searchAirportsWithTerm(term: String) {
        self.typeaheadResults = self.airports.filter { $0.lowercaseString.containsString(term.lowercaseString) }
    }
    
    func numberOfRowsForSection(section: Int) -> Int {
        return self.typeaheadResults.count
    }
    
    func stringForIndexPath(indexPath: NSIndexPath) -> String {
        return self.typeaheadResults[indexPath.row]
    }
    
}