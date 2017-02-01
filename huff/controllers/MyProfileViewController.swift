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
    
    var profile: Profile?
    var runAddHandle: FIRDatabaseHandle?
    var runRemoveHandle: FIRDatabaseHandle?
    var bestPaceHandle: FIRDatabaseHandle?
    var bestDistanceHandle: FIRDatabaseHandle?

    // MARK: - outlets
    @IBOutlet weak var profileInfoHeader: ProfileHeaderView!
    @IBOutlet weak var bestPaceLabel: UILabel!
    @IBOutlet weak var bestDistanceLabel: UILabel!
    @IBOutlet weak var favoritedActiveRuns: UITableView! {
        didSet {
            favoritedActiveRuns.delegate = self
            favoritedActiveRuns.dataSource = self
            favoritedActiveRuns.rowHeight = UITableViewAutomaticDimension
            favoritedActiveRuns.estimatedRowHeight = 150
        }
    }
    
    // MARK: - initialization
    deinit {
        FirebaseService.sharedInstance().removeObserver(handler: runAddHandle)
        FirebaseService.sharedInstance().removeObserver(handler: runRemoveHandle)
        FirebaseService.sharedInstance().removeObserver(handler: bestPaceHandle)
        FirebaseService.sharedInstance().removeObserver(handler: bestDistanceHandle)
    }

    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let firebaseUser = FirebaseService.getCurrentUser()
        profile = Profile(user: firebaseUser, photo: nil, status: nil, dateJoined: nil)
        
        fetchProfileData {
             self.fetchProfilePhoto(profilePhotoUrl: firebaseUser.photoURL) { ()->Void in
                self.bestPaceHandle = FirebaseService.sharedInstance().fetchBestPace() { (localSnapshot)->Void in
                    guard let bestPaceRunDict = localSnapshot.value as? [String: Any] else {
                        print("Best pace not available")
                        return
                    }
                    let run = Run(dict: bestPaceRunDict)
                    let pace = run.determinePaceString()
                    
                    self.bestPaceLabel.text = "\(pace) min/mile"
                }
                
                self.bestDistanceHandle = FirebaseService.sharedInstance().fetchBestDistance(completionHandler: { (localSnapshot) in
                    guard let bestDistance = localSnapshot.value as? Double else {
                        print("Best pace not available")
                        return
                    }
                    self.bestDistanceLabel.text = String(format: "%.2f", Run.distanceInMiles(meters: bestDistance)) + " miles"
                })
            }
        }
        fetchFavoritedRuns()
        
        // set back button for upcoming vc
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
    }

    
    // MARK: - action
    @IBAction func logout(_ sender: Any) {
        giveWarning(title: "Logout", message: "Are you sure you'd like to log off?") { (action) -> Void in
            FirebaseService.sharedInstance().logout(completion: { (error) in
                FirebaseService.destroy()
                
                // it seems that googles sdk remembers the users and logs in automatically with their oauth token
                // revokes the current google login
                GIDSignIn.sharedInstance().disconnect()
            })
        }
    }
    
    func showOptions(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            // 1. extract the cell and object associated
            guard let cell = gesture.view as? ActiveRunTableViewCell, let run = cell.run else {
                return
            }
            // 2. create the alert controller
            let alertVC = UIAlertController(title: "Event Options for \(run.name ?? run.organization.name ?? "N/A")", message: "", preferredStyle: .actionSheet)
            // 3. create the actions
            if let phone = run.organization.phone, UIDevice.current.model == "iPhone" {
                alertVC.addAction(UIAlertAction(title: "Call Organizer", style: .default, handler: { (action) in
                    guard let phoneURL = URL(string: "telprompt://" + phone) else { return }
                    UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
                }))
            }
            // set option to delete the run
            alertVC.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                if let id = run.assetID {                    
                    FirebaseService.sharedInstance().removeRunWith(id: id, completionHandler: nil)
                }
            }))
            
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alertVC, animated: true)
        default: break
        }
        

    }
    
    // MARK: - data fetching
    
    // step 1: grab information from the database
    func fetchProfileData(completionHandler: (()->Void)?) {
        FirebaseService.sharedInstance().fetchAccountNode { (localSnapshot) in
            let snap = localSnapshot.value as? [String: Any]
            self.profile?.status = snap?["status"] as? String
            self.profile?.accountCreationDate = snap?["creation_date"] as? TimeInterval
            
            completionHandler?()
        }
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
        completionHandler?()
    }
    
    func fetchFavoritedRuns() {
        runRemoveHandle = FirebaseService.sharedInstance().observeLikedRuns(eventType: .childAdded) { (localSnapshot) in
            guard let snapshot = localSnapshot.value as? [String: Any] else {
                return
            }
            if let run = ActiveRun(result: snapshot) {
                self.profile?.favoriteActiveRuns.append(run)
                self.favoritedActiveRuns.insertRows(at: [IndexPath(row: self.profile!.favoriteActiveRuns.count-1, section: 0)], with: .automatic)
            }
        }
        
        runAddHandle = FirebaseService.sharedInstance().observeLikedRuns(eventType: .childRemoved) { (localSnapshot) in
            guard let snapshot = localSnapshot.value as? [String: Any] else {
                return
            }
            // the run must have a uid
            guard let uid = snapshot[ActiveRun.Key.AssetUID] as? String else {
                print("error - the run does not consist of any uid")
                return
            }
            // find the index of the run with the same uid
            if let index = self.profile?.favoriteActiveRuns.index(where: { (run) -> Bool in
                return run.assetID == uid
            }) {
                self.profile?.favoriteActiveRuns.remove(at: index)
                self.favoritedActiveRuns.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            }
        }
    }
    
    fileprivate func updateProfile() {
        DispatchQueue.main.async(execute: {
            // step 3: assign the profile header view a new profile object
            self.profileInfoHeader.profile = self.profile
        })
    }
    
    // MARK: - navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRunDetail" {
            let cell = sender as? ActiveRunTableViewCell
            let detailVC = segue.destination as! ActiveRunDetailViewController
            detailVC.run = cell?.run
        } else if segue.identifier == "ShowAttributions" {
            let creditVC = segue.destination as! CreditViewController
            creditVC.title = sender as? String
        }
    }
}

extension MyProfileViewController {
    // MARK: - setting options
    
    @IBAction func settings(_ sender: Any) {
        let alertVC = UIAlertController(title: "Settings", message: "", preferredStyle: .actionSheet)
        
        // add privacy policy option
        alertVC.addAction(UIAlertAction(title: "Privacy Policy", style: .default, handler: { (action) in
            let privacyPolicyVC = self.storyboard?.instantiateViewController(withIdentifier: "privacyPolicyVC") as! TextViewController
            self.navigationController?.pushViewController(privacyPolicyVC, animated: true)
        }))
        
        alertVC.addAction(UIAlertAction(title: "Terms of Service", style: .default, handler: { (action) in
            let privacyPolicyVC = self.storyboard?.instantiateViewController(withIdentifier: "TOS") as! TextViewController
            self.navigationController?.pushViewController(privacyPolicyVC, animated: true)
        }))
        
        // add attribution option
        alertVC.addAction(UIAlertAction(title: "Third Party Notices", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "ShowAttributions", sender: "Third Party Notices")
        }))
        
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
}
