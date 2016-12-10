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

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        /*
         reenable this for non developer mode
         remoteConfig.fetch { (status: FIRRemoteConfigFetchStatus, error: Error?) in
            if status == .success {
                print("remote fetch successful")
                
                self.remoteConfig.activateFetched()
                let quote = self.remoteConfig["quote"]
                let author = self.remoteConfig["author"]
                
                if quote.source != .static && author.source != .static {
                    DispatchQueue.main.async(execute: {
                        self.quoteLabel.text = "\"" + (quote.stringValue ?? "") + "\""
                        self.quoteAuthor.text = "- " + (author.stringValue ?? "")
                        
                        self.quoteLabel.frame = self.quoteLabel.bounds.insetBy(dx: 10, dy: 10)
                        // self.quoteLabel.setNeedsDisplay()
                        
                        print("applying the quote: \(quote.stringValue ?? "")\nwith the author as: \(author.stringValue ?? "")")
                    })
                }
            }
        }*/
        
        var expirationDuration: TimeInterval!
        if remoteConfig.configSettings.isDeveloperModeEnabled {
            expirationDuration = 0
        }
        
        remoteConfig.fetch(withExpirationDuration: expirationDuration) { (status, error) in
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
