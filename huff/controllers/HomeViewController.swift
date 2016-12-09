//
//  HomeViewController.swift
//  huff
//
//  Created by Xing Hui Lu on 11/24/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    // MARK: - outlets
    @IBOutlet weak var quoteLabel: UILabel!

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Email verified: \(FIRAuth.auth()?.currentUser?.isEmailVerified ?? false)")
        
        // TODO: populate quoteLabel based on the remote config on firebase
        quoteLabel?.sizeToFit()
    }

    // MARK: - actions
    @IBAction func startARun(_ sender: Any) {
        performSegue(withIdentifier: "beginRun", sender: self)
    }
    
    @IBAction func showRunHistory(_ sender: Any) {
        // TODO: show run history view
    }
 

}
