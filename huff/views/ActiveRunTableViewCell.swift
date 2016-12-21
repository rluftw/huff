//
//  ActiveRunTableViewCell.swift
//  huff
//
//  Created by Xing Hui Lu on 12/3/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit

class ActiveRunTableViewCell: UITableViewCell {
    // MARK: - properties
    var run: ActiveRun! {
        didSet {
            organizationNameLabel.text = run.organization.name ?? "Organization navailable"
            runName.text = run.name
            
            let calendar = Calendar.current
            let today = Date()
            if let runDate = run.runDate {
                let components = calendar.dateComponents([.day], from: today, to: runDate)
                let day = components.day ?? 0
                
                dateLabel?.text = day == 0 ? "tomorrow": "\(day) day(s) till run"
            } else {
                dateLabel?.text = ""
            }
        }
    }
    
    // MARK: - outlets
    @IBOutlet weak var organizationNameLabel: UILabel!
    @IBOutlet weak var runName: UILabel!
    @IBOutlet weak var dateLabel: UILabel?
}
