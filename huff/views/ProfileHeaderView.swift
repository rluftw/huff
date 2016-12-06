//
//  ProfileHeaderView.swift
//  huff
//
//  Created by Xing Hui Lu on 12/5/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIView {

    var profile: Profile! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profileDescription: UILabel!
    @IBOutlet weak var memberSince: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

}
