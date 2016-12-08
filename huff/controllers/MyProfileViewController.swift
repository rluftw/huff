//
//  MyProfileViewController.swift
//  huff
//
//  Created by Xing Hui Lu on 12/5/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit
import FirebaseAuth

class MyProfileViewController: UIViewController {

    // MARK: - properties
    var profile: Profile!
    
    // MARK: - outlets
    @IBOutlet weak var profileInfoTable: UITableView!
    @IBOutlet weak var profileInfoHeader: ProfileHeaderView!
    @IBOutlet weak var tapGesture: UITapGestureRecognizer!

    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // send this information into the header
        profileInfoHeader.profile = profile
        
        tapGesture.addTarget(self, action: #selector(editProfile))
        profileInfoTable.backgroundColor = UIColor(patternImage: UIImage(named: "brickwall")!)
    }
    
    // MARK: - action
    
    @IBAction func logout(_ sender: Any) {
        do {
            try FIRAuth.auth()?.signOut()
        } catch _ {}
        tabBarController?.dismiss(animated: true, completion: nil)
    }
    
    func editProfile() {
        print("TEST")
    }
    
    
}
