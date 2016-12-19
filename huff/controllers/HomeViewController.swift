//
//  HomeViewController.swift
//  huff
//
//  Created by Xing Hui Lu on 11/24/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class HomeViewController: UIViewController {

    // MARK: - outlets
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var quoteAuthor: UILabel!
    
    @IBOutlet weak var topDistanceTable: UITableView!
    
    // MARK: - properties
    var remoteConfig: FIRRemoteConfig!
    var ref: FIRDatabaseReference!
    var topRecords = [TopRunRecord]()
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // first step is check if this is the users first time logging in
        configureDatabase()
        
        // configure the remote configuration
        configureRemoteConfig()
        
        // fetch the remote configurations
        fetchConfigurations()
        
        // select the first row
        topDistanceTable.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
        
    }
    
    
    // MARK: - actions
    @IBAction func startARun(_ sender: Any) {
        performSegue(withIdentifier: "beginRun", sender: self)
    }
    
    @IBAction func showRunHistory(_ sender: Any) {
        // TODO: show run history view
    }
    
    // MARK: - configurations for firebase
    func configureRemoteConfig() {
        let settings = FIRRemoteConfigSettings(developerModeEnabled: true)
        remoteConfig = FIRRemoteConfig.remoteConfig()
        remoteConfig.configSettings = settings!
    }

    func fetchConfigurations() {
        
        // fetch the quote and the author
        remoteConfig.fetch(withExpirationDuration: 0) { (status: FIRRemoteConfigFetchStatus, error: Error?) in
            if status == .success {
                print("remote fetch successful")
                
                self.remoteConfig.activateFetched()
                let quote = self.remoteConfig["quote"]
                let author = self.remoteConfig["author"]
                
                if quote.source != .static && author.source != .static {
                    DispatchQueue.main.async(execute: {
                        self.quoteLabel.text = "\"" + (quote.stringValue ?? "") + "\""
                        self.quoteAuthor.text = "- " + (author.stringValue ?? "")
                        
                        print("applying the quote: \(quote.stringValue ?? "")\nwith the author as: \(author.stringValue ?? "")")
                    })
                }
            }

        }
    }
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        
        let userReference = ref.child("users/\(FIRAuth.auth()!.currentUser!.uid)")
        userReference.observeSingleEvent(of: .value, with: { (localSnapshot) in
            guard let snapshot = localSnapshot.value as? [String: Any], let _ = snapshot["creation_date"] as? TimeInterval else {
                print("no creation date found - attempting to set a creation date")
                
                userReference.setValue(["creation_date": Date().timeIntervalSince1970])
                return
            }
        })
        
        // create the values to locate the node on firebase
        let components = Calendar.current.dateComponents([.weekOfYear, .year], from: Date())
        guard let weekOfYear = components.weekOfYear, let year = components.year else {
            return
        }
    
        let topRunnersRef = ref.child("global_runs/week\(weekOfYear)-\(year)")
        topRunnersRef
            .observeSingleEvent(of: .value, with: { (localSnapshot) in
            guard let snapshot = localSnapshot.value as? [String: Any] else {
                print("invalid snapshot format")
                return
            }
            
            for key in snapshot.keys {
                let record = TopRunRecord(dict: snapshot[key] as! [String: Any])
                self.topRecords.append(record)
            }
                
            self.topDistanceTable.reloadData()
        })
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topListCell", for: indexPath) as! TopListCell
        
        cell.rankLabel.text = "\(indexPath.row+1)."
    
        
//        let record = topRecords[indexPath.row]
//        cell.userLabel.text = "\(record.username ?? "")"
//        cell.
        
        // the only row that should be highlighted will be the first
        cell.isUserInteractionEnabled = indexPath.row == 0
        
        return cell
    }
}
