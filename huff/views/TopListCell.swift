//
//  TopListCell.swift
//  huff
//
//  Created by Xing Hui Lu on 12/17/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit

class TopListCell: UITableViewCell {
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = UIColor(red: 0, green: 153/255.0, blue: 0, alpha: 1)
    }
}
