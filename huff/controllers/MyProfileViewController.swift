//
//  MyProfileViewController.swift
//  huff
//
//  Created by Xing Hui Lu on 12/5/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class MyProfileViewController: UIViewController {
    
    // TODO: change this profile into a custom profile model
    var profile: FIRUser!
    
    // MARK: - outlets
    @IBOutlet weak var profileInfoHeader: ProfileHeaderView!
    @IBOutlet weak var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // there should always be a current user, otherwise 
        // app delegate would automaticlly sign this app off
        profile = FIRAuth.auth()!.currentUser!
                
        // send this information into the header
        profileInfoHeader.profile = profile
        
    }
    
    // MARK: - action
    
    @IBAction func logout(_ sender: Any) {
        giveWarning(title: "Logout", message: "Are you sure you'd like to log off?") { (action) -> Void in
            let providerID = FIRAuth.auth()?.currentUser?.providerID ?? "N/A"
            do {
                try FIRAuth.auth()?.signOut()
            } catch let error {
                print("there was an error signing this user out: \(error.localizedDescription)")
            }
            
            if providerID == "Firebase" {
                print("Revoking current google login")
                GIDSignIn.sharedInstance().disconnect()
            }
        }
    }
    
    func editProfile() {
        print("Attempting to edit profile")
    }
    
    // MARK: - helper methods
    func giveWarning(title: String, message: String, yesAction: @escaping (UIAlertAction)->Void) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: yesAction))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
}

