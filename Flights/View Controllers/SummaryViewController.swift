//
//  SummaryViewController.swift
//  Flights
//
//  Created by Kyle Yoon on 8/18/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController {
    @IBOutlet var summaryStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Summary"
    }
}
