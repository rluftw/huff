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
import Firebase

class MyProfileViewController: UIViewController {
    
    // TODO: change this profile into a custom profile model
    var profile: Profile?
    var databaseRef: FIRDatabaseReference?
    var accountRef: FIRDatabaseHandle?
    
    // MARK: - outlets
    @IBOutlet weak var profileInfoHeader: ProfileHeaderView!

    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let firebaseUser = FIRAuth.auth()!.currentUser!
        self.profile = Profile(user: firebaseUser, photo: nil, status: nil, dateJoined: nil)
     
        configureDatabase { 
            self.fetchProfilePhoto(profilePhotoUrl: firebaseUser.photoURL)
        }
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
            
            // it seems that googles sdk remembers the users, and logs in automatically with their oauth screen
            if providerID == "Firebase" {
                print("Revoking current google login")
                GIDSignIn.sharedInstance().disconnect()
            }
        }
    }

    // MARK: - helper methods
    func giveWarning(title: String, message: String, yesAction: @escaping (UIAlertAction)->Void) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: yesAction))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    
    // MARK: - firebase methods
    
    // step 1: grab information from the database
    func configureDatabase(completionHandler: (()->Void)?) {
        databaseRef = FIRDatabase.database().reference()
        accountRef = databaseRef?.child("users/\(FIRAuth.auth()!.currentUser!.uid)").observe(.value, with: { (localSnapshot) in
            let snap = localSnapshot.value as? [String: Any]
            self.profile?.status = snap?["status"] as? String
            self.profile?.accountCreationDate = snap?["creation_date"] as? TimeInterval
            
            completionHandler?()
        })
    }

    // step 2: fetch the image
    func fetchProfilePhoto(profilePhotoUrl: URL?) {
        if let url = profilePhotoUrl {
            let request = URLRequest(url: url)
            _ = NetworkOperation.sharedInstance().request(request, completionHandler: { (data, error) in
                if let data = data, let image = UIImage(data: data) {
                    self.profile?.photo = image
                }
                self.updateProfile()
            })
        } else {
            self.updateProfile()
        }
    }
    
    fileprivate func updateProfile() {
        DispatchQueue.main.async(execute: {
            // step 3: assign the profile header view a new profile object
            self.profileInfoHeader.profile = self.profile
        })
    }
}
