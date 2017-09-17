//
//  ActiveRunDetailViewController.swift
//  huff
//
//  Created by Xing Hui Lu on 12/3/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit
import Firebase

class ActiveRunDetailViewController: UIViewController {

    // MARK: - properties
    var run: ActiveRun!
    
    // MARK: - outlets
    @IBOutlet weak var organizationName: UILabel!
    @IBOutlet weak var runName: UILabel!
    @IBOutlet weak var runDescription: UITextView!
    @IBOutlet weak var runDate: UILabel!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentingViewController?.tabBarController?.tabBar.isHidden = true
        
        checkRunStatus()
        updateLabels()
        
        // check if the run has passed
        if let runDate = run.runDate, Date().compare(runDate) == .orderedDescending {
            registerButton.setTitle("NOT AVAILABLE", for: .normal)
            registerButton.isUserInteractionEnabled = false
            registerButton.alpha = 0.5
        }
    }

    // MARK: - helper methods
    func updateLabels() {
        organizationName?.text = run.organization.name
        runName?.text = run.name
        
        // set description and have scroll position to the top
        runDescription?.text = run.runDescription
        runDescription?.scrollRangeToVisible(NSMakeRange(0, 0))
        
        // this seems like a bug - text is getting cut off
        // the following forces the full rendering
        runDescription?.isScrollEnabled = false
        runDescription?.isScrollEnabled = true
        
        // calculate how many days are left till run
        if let dateRun = run.runDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            runDate?.text = "Run on: " + formatter.string(from: dateRun)
        }
        
        // check if theres a number for the organization and the device is an iphone
        if let _ = run.organization.phone, UIDevice.current.model == "iPhone" {
            contactButton?.isHidden = false
        }
    }
    
    func updateLikeButton(liked: Bool) {
        DispatchQueue.main.async { 
            self.likeButton.setImage(UIImage(named: liked ? "like": "unlike"), for: .normal)
        }
    }
    
    // MARK: - actions
    @IBAction func close(_ sender: Any) {
        presentingViewController?.tabBarController?.tabBar.isHidden = false
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func register(_ sender: Any) {
        guard let registrationLink = run.registrationURL, let registrationURL = URL(string: registrationLink) else {
            registerButton.setTitle("NOT AVAILABLE", for: .normal)
            return
        }
        UIApplication.shared.open(registrationURL, options: [:], completionHandler: nil)
    }
    
    @IBAction func contactOrganizer(_ sender: Any) {
        guard let phone = run.organization.phone, let phoneURL = URL(string: "telprompt://" + phone) else { return }
        UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
    }
    
    @IBAction func like(_ sender: Any) {
        toggleLike()
    }
    
    // MARK: - firebase
    func checkRunStatus() {
        FirebaseService.sharedInstance().fetchActiveRunLikeStatus { (localSnapshot) in
            self.updateLikeButton(liked: localSnapshot.hasChild(self.run.assetID))
        }
    }
    
    // updates firebase db when user wants to either like or unlike a run
    private func toggleLike() {
        FirebaseService.sharedInstance().fetchActiveRunLikeStatus { (localSnapshot) in
            // true if snapshot contains the child
            let hasChild = localSnapshot.hasChild(self.run.assetID)
            
            FirebaseService.sharedInstance().activeRunAction(action: hasChild ? .Remove: .Add, run: self.run) {
                self.updateLikeButton(liked: !hasChild)
            }
        }
    }
}
