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
    var accountHandle: FIRDatabaseHandle?
    var runAddHandle: FIRDatabaseHandle?
    var runRemoveHandle: FIRDatabaseHandle?
    
    // MARK: - outlets
    @IBOutlet weak var profileInfoHeader: ProfileHeaderView!
    @IBOutlet weak var favoritedActiveRuns: UITableView! {
        didSet {
            favoritedActiveRuns.delegate = self
            favoritedActiveRuns.dataSource = self
            favoritedActiveRuns.rowHeight = UITableViewAutomaticDimension
            favoritedActiveRuns.estimatedRowHeight = 150
        }
    }

    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let firebaseUser = FIRAuth.auth()!.currentUser!
        self.profile = Profile(user: firebaseUser, photo: nil, status: nil, dateJoined: nil)
     
        databaseRef = FIRDatabase.database().reference()
        configureDatabase {
            self.fetchProfilePhoto(profilePhotoUrl: firebaseUser.photoURL, completionHandler: nil)
        }
        fetchFavoritedRuns()
    }
    
    deinit {
        if let addHandle = runAddHandle { databaseRef?.removeObserver(withHandle: addHandle) }
        if let removeHandle = runRemoveHandle { databaseRef?.removeObserver(withHandle: removeHandle)}
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
        accountHandle = databaseRef?.child("users/\(FIRAuth.auth()!.currentUser!.uid)").observe(.value, with: { (localSnapshot) in
            let snap = localSnapshot.value as? [String: Any]
            self.profile?.status = snap?["status"] as? String
            self.profile?.accountCreationDate = snap?["creation_date"] as? TimeInterval
            
            completionHandler?()
        })
    }

    // step 2: fetch the image
    func fetchProfilePhoto(profilePhotoUrl: URL?, completionHandler: (()->Void)?) {
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
    
    func fetchFavoritedRuns() {
        runAddHandle = databaseRef?.child("users/\(FIRAuth.auth()!.currentUser!.uid)/liked_runs").observe(.childAdded, with: { (localSnapshot) in
            guard let snapshot = localSnapshot.value as? [String: Any] else {
                return
            }
            
            print("childAdded")
            if let run = ActiveRun(result: snapshot) {
                self.profile?.favoriteActiveRuns.append(run)
                self.favoritedActiveRuns.insertRows(at: [IndexPath(row: self.profile!.favoriteActiveRuns.count-1, section: 0)], with: .automatic)
            }
        })
        
        runRemoveHandle = databaseRef?.child("users/\(FIRAuth.auth()!.currentUser!.uid)/liked_runs").observe(.childRemoved, with: { (localSnapshot) in
            guard let snapshot = localSnapshot.value as? [String: Any] else {
                return
            }
            
            print("childRemoved")
            
            // the run must have a uid
            guard let uid = snapshot[ActiveRun.Key.AssetUID] as? String else {
                print("error - the run does not consist of any uid")
                return
            }
            
            print("the user has liked \(self.profile!.favoriteActiveRuns.count) runs")
            
            if let index = self.profile?.favoriteActiveRuns.index(where: { (run) -> Bool in
                return run.assetID == uid
            }) {
                self.profile?.favoriteActiveRuns.remove(at: index)
                self.favoritedActiveRuns.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            }
            
        })
    }
    
    fileprivate func updateProfile() {
        DispatchQueue.main.async(execute: {
            // step 3: assign the profile header view a new profile object
            self.profileInfoHeader.profile = self.profile
        })
    }
}

extension MyProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profile?.favoriteActiveRuns.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activeRunCell", for: indexPath) as! ActiveRunTableViewCell
        cell.run = self.profile?.favoriteActiveRuns[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        // use the cell as the sender - used later to extract the active run object
        let cell = tableView.cellForRow(at: indexPath)
        performSegue(withIdentifier: "showRunDetail", sender: cell)
    }
    
    // MARK: - navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRunDetail" {
            let cell = sender as? ActiveRunTableViewCell
            let detailVC = segue.destination as! ActiveRunDetailViewController
            detailVC.run = cell?.run
            
            tabBarController?.tabBar.isHidden = true
        }
    }
}
