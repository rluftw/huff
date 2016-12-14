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

    var profile: Profile? {
        didSet {
            if let photo = profile?.photo {
                profilePhoto.image = photo
            }
            name.text = profile?.displayName ?? profile?.email ?? profile?.uid
            
            if let accountCreationDate = profile?.accountCreationDate {
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                memberSince.text = "member since: \(formatter.string(from: Date(timeIntervalSince1970: accountCreationDate)))"
            }
            
            profileDescription.text = profile?.status ?? "Tap here to change your status"
        }
    }
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profileDescription: UILabel!
    @IBOutlet weak var memberSince: UILabel!
    
}
