//
//  File.swift
//  Flights
//
//  Created by Kyle Yoon on 2/11/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import UIKit
import SwiftyJSON

class TripsViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var tripsData: JSON?
    var trips: [JSON]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tripsData = self.tripsData?.dictionaryValue {
            self.trips = tripsData["trips"]!["tripOption"].arrayValue
        }
    }
    
}

extension TripsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let trips = self.trips {
            return trips.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let trip = self.trips?[indexPath.row].dictionaryValue {
            let tripCell = tableView.dequeueReusableCellWithIdentifier("tripCell", forIndexPath: indexPath)
            let saleTotal = trip["pricing"]![0]["saleTotal"].stringValue
            tripCell.textLabel?.text = saleTotal
            
            return tripCell
        }
        
        return UITableViewCell()
    }
    
}

extension TripsViewController: UITableViewDelegate {
    
}
