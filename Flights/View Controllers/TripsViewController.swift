//
//  File.swift
//  Flights
//
//  Created by Kyle Yoon on 2/11/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

// TODO: Implement logic to grab departures, save returns until user taps a departure

import UIKit

enum TripSelectionStatus {
    case selectedNone
    case selectedDeparture
    case selectedReturn
}

class TripsViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var searchResults: SearchResults?
    var selectedTripOption: TripOption?
    var tripsDataSource: TripsDataSource?
    var isRoundTrip: Bool = true
    let flightDetailSegueIdentifier =  "flightDetailSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Trips"
        self.tableView.registerNib(UINib(nibName: TripCell.cellIdentifier, bundle: nil),
            forCellReuseIdentifier: TripCell.cellIdentifier)
        self.tableView.registerNib(UINib(nibName: TripHeaderView.cellIdentifier, bundle: nil),
            forHeaderFooterViewReuseIdentifier: TripHeaderView.cellIdentifier)
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
                cell.configure(tripsDataSource.tripCellDataForIndexPath(indexPath))
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.tableView.numberOfSections == 2 {
            if let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(TripHeaderView.cellIdentifier) as? TripHeaderView {
                switch section {
                case 1:
                    if let tripsDataSource = self.tripsDataSource {
                        switch tripsDataSource.tripSelectionStatus {
                        case .selectedDeparture:
                            headerView.sectionTitleLabel.text = "Choose your return flight"
                        case .selectedReturn:
                            headerView.sectionTitleLabel.text = "Selected return flight"
                        default:
                            return nil
                        }
                        
                        return headerView
                    }
                case 0:
                    fallthrough
                default:
                    headerView.sectionTitleLabel.text = "Selected departure flight"
                    return headerView
                }
            }

            return nil
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.tableView.numberOfSections == 2 {
            switch section {
            case 1:
                fallthrough
            case 0:
                fallthrough
            default:
                return 100.0
            }
        }
        
        return 0
    }
    
}

extension TripsViewController: UITableViewDelegate {
    // TODO: Add selection behavior when trip option is all selected
    // TODO: Add selection behavior for one way
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let dataSource = self.tripsDataSource {
            switch dataSource.tripSelectionStatus {
            case .selectedNone:
                dataSource.tripSelectionStatus = .selectedDeparture
                dataSource.configureReturnFlights(for: indexPath)
            case .selectedDeparture:
                dataSource.tripSelectionStatus = .selectedReturn
                dataSource.configureCompletedRoundTrip(for: indexPath)
            default:
                return
            }
            self.tableView.reloadData()
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0),
                                                  atScrollPosition: .Top,
                                                  animated: true)
        }
    }
    
}
