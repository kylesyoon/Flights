//
//  TripHeaderView.swift
//  Flights
//
//  Created by Kyle Yoon on 3/6/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import UIKit

protocol TripHeaderViewDelegate {
    
    func headerViewDidTapClear(headerView: TripHeaderView)
    
}

class TripHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet var sectionTitleLabel: UILabel!
    static let cellIdentifier = "TripHeaderView"
    var delegate: TripHeaderViewDelegate?
    var type: TripSelectionStatus = .selectedNone
    
    @IBAction func didTapRemoveButton(sender: AnyObject) {
        self.delegate?.headerViewDidTapClear(self)
    }
    
}