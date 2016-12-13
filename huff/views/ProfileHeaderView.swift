//
//  ProfileHeaderView.swift
//  huff
//
//  Created by Xing Hui Lu on 12/5/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit
import Firebase

class ProfileHeaderView: UIView {

    var profile: FIRUser! {
        didSet {
            name.text = profile.displayName ?? profile.email?.components(separatedBy: "@")[0] ?? profile.uid
            
        }
    }
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profileDescription: UILabel!
    @IBOutlet weak var memberSince: UILabel!
}
