//
//  DatePickerButton.swift
//  SFHacks
//
//  Created by Shun Sato on 3/2/19.
//  Copyright © 2019 ShunSato. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class DatePickerButton: UIView {
    var minimumDate: Date = Date()
    var maximumDate: Date = Date.distantFuture
    
    private(set) var currentDate: Date = Date() {
        didSet {
            updateDateLabel()
        }
    }
    
    @IBOutlet private weak var currentDateLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let view = Bundle.main.loadNibNamed("DatePickerButton", owner: self, options: nil)?[0] as! UIView
        addSubview(view)
        view.frame = bounds
        
        updateDateLabel()
    }
    
    private func updateDateLabel() {
        currentDateLabel.text = "\(currentDate.month) \(currentDate.day)  \(currentDate.hour) : \(currentDate.minute)"
    }

    @IBAction func onTapped(_ sender: UIButton) {
        let datePicker = ActionSheetDatePicker(title: "Date:", datePickerMode: .dateAndTime, selectedDate: Date(), target: self, action: #selector(DatePickerButton.onDatePicked), origin: self)
        datePicker?.minimumDate = minimumDate
        datePicker?.maximumDate = maximumDate
        datePicker?.show()
    }
    
    @objc private func onDatePicked(date: Date) {
        currentDate = date
    }
}
