//
//  DateViewController.swift
//  Flights
//
//  Created by Kyle Yoon on 2/29/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import UIKit

protocol DateViewControllerDelegate {
    func dateViewController(dateViewController: DateViewController, didTapDoneWithDate date: NSDate)
}

class DateViewController: UIViewController {
    
    static let departureDateSegueIdentifier = "departureDateSegueIdentifier"
    static let returnDateSegueIdentifier = "returnDateSegueIdentifier"
    
    var isDeparture: Bool = true
    var delegate: DateViewControllerDelegate?
    
    @IBOutlet var datePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.datePicker.minimumDate = NSDate()
    }
    
    @IBAction func didTapDoneButton(sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.dateViewController(self,
                didTapDoneWithDate: self.datePicker.date)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
