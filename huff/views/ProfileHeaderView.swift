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
            
            if let photoURL = profile.photoURL{
                let request = URLRequest(url: photoURL)
                _ = NetworkOperation.sharedInstance().request(request, completionHandler: { (data, error) in
                    guard error == nil else {
                        self.activityIndicator.stopAnimating()
                        return
                    }
                    
                    DispatchQueue.main.async(execute: {
                        self.profilePhoto.image = UIImage(data: data!)
                        self.activityIndicator.stopAnimating()
                    })
                })
            } else {
                self.activityIndicator.stopAnimating()
            }
            
            isUserInteractionEnabled = true
        }
        willSet {
            isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profileDescription: UILabel!
    @IBOutlet weak var memberSince: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
}
