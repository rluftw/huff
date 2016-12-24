//
//  PastRunTableViewCell.swift
//  huff
//
//  Created by Xing Hui Lu on 12/20/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit


class PastRunTableViewCell: UITableViewCell {

    var run: Run! {
        didSet {
            // set distance
            self.distance.text = "\(run.distanceInMiles()) miles"
            
            // set date
            self.date.text = run.dateString()
            
            // set pace
            self.pace.text = "PACE: \(run.determinePaceString()) min/mile"
            
            // set duration
            let durationValues = run.determineDuration()
            let hours = Int(durationValues.hour)
            let minutes = Int(durationValues.min)
            duration.text = "\((minutes ?? 0)+((hours ?? 0)*60)):\(durationValues.sec)"
        }
    }
    
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var pace: UILabel!
    @IBOutlet weak var date: UILabel!
}
