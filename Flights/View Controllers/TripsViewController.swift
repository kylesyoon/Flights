//
//  File.swift
//  Flights
//
//  Created by Kyle Yoon on 2/11/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

// TODO: Implement logic to grab departures, save returns until user taps a departure

import UIKit
import SwiftyJSON

class TripsViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var departureTripRequest: TripRequest?
    var searchResults: SearchResults?
    var returnSearchResults: SearchResults?
    var selectedTripOption: TripOption?
    var tripsDataSource: TripsDataSource?
    var isRoundTrip: Bool = true
    
    let flightDetailSegueIdentifier =  "flightDetailSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: TripCell.cellIdentifier, bundle: nil),
            forCellReuseIdentifier: TripCell.cellIdentifier)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 134.0
        if let searchResults = self.searchResults {
            self.tripsDataSource = TripsDataSource(searchResults: searchResults)
            self.tableView.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == flightDetailSegueIdentifier {
            let tripDetailVC = segue.destinationViewController as! TripDetailViewController
            tripDetailVC.tripOption = self.selectedTripOption
        }
    }
    
}

extension TripsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let tripsDataSource = self.tripsDataSource {
            return tripsDataSource.numberOfSections()
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tripsDataSource = self.tripsDataSource {
            return tripsDataSource.numberOfRowsForSection(section)
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(TripCell.cellIdentifier, forIndexPath: indexPath) as? TripCell {
            if let tripsDataSource = self.tripsDataSource {
                cell.configure(tripsDataSource.tripOptionForIndexPath(indexPath))
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
}

extension TripsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.tripsDataSource?.selectedTripOptionAtIndexPath(indexPath)
        self.tableView.reloadData()
    }
    
}
