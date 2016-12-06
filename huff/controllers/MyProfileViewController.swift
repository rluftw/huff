//
//  MyProfileViewController.swift
//  huff
//
//  Created by Xing Hui Lu on 12/5/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController {

    // MARK: - properties
    var profile: Profile!
    
    // MARK: - outlets
    @IBOutlet weak var profileInfoTable: UITableView!
    @IBOutlet weak var profileInfoHeader: ProfileHeaderView!
    
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // send this information into the header
        profileInfoHeader.profile = profile
    }
}
