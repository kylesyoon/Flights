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
    
    var searchResults: SearchResults?
    var selectedTripOption: TripOption?
    
    let flightDetailSegueIdentifier =  "flightDetailSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateComponents = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: (self.searchResults?.trips.tripOption[0].slice[0].segment[0].leg[0].departureTime)!)
        self.navigationItem.title = "Trips on \(dateComponents.month)/\(dateComponents.day)/\(dateComponents.year)"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == flightDetailSegueIdentifier {
            let tripDetailVC = segue.destinationViewController as! TripDetailViewController
            tripDetailVC.tripOption = self.selectedTripOption
        }
    }
    
}

extension TripsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let searchResults = self.searchResults {
            return searchResults.trips.tripOption.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let tripOption = self.searchResults?.trips.tripOption[indexPath.row] {
            let cell = tableView.dequeueReusableCellWithIdentifier("tripCell", forIndexPath: indexPath)
            cell.textLabel?.text = tripOption.slice[0].segment[0].flight.carrier + " " + tripOption.slice[0].segment[0].flight.number + " " + tripOption.pricing[0].saleTotal
            let dateComponents = NSCalendar.currentCalendar().components([.Hour, .Minute], fromDate: tripOption.slice[0].segment[0].leg[0].departureTime)
            cell.detailTextLabel?.text = "Departing \(dateComponents.hour):\(dateComponents.minute)"
            
            return cell
        }
        
        return UITableViewCell()
    }
    
}

extension TripsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let tripOption = self.searchResults?.trips.tripOption[indexPath.row] {
            self.selectedTripOption = tripOption
            self.performSegueWithIdentifier(flightDetailSegueIdentifier, sender: nil)
        }
    }
    
}
