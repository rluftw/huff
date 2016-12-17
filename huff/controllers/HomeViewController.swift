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
    
    // MARK: - properties
    var remoteConfig: FIRRemoteConfig!
    var ref: FIRDatabaseReference!
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // first step is check if this is the users first time logging in
        configureDatabase()
        
        // configure the remote configuration
        configureRemoteConfig()
        
        // fetch the remote configurations
        fetchConfigurations()
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
    }
    
}
