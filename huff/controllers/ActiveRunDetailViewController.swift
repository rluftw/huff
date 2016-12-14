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
    var ref: FIRDatabaseReference!
    
    // MARK: - outlets
    @IBOutlet weak var organizationName: UILabel!
    @IBOutlet weak var runName: UILabel!
    @IBOutlet weak var runDescription: UITextView!
    @IBOutlet weak var runDate: UILabel!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        updateLabels()
    }
    
    deinit {
        
    }
    
    // MARK: - helper methods
    func updateLabels() {
        organizationName?.text = run.organization.name
        runName?.text = run.name
        
        // set description and have scroll position to the top
        runDescription?.text = run.runDescription
        runDescription?.scrollRangeToVisible(NSMakeRange(0, 0))
        
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
    
    // MARK: - actions
    
    @IBAction func close(_ sender: Any) {
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
        
    }
 
    
    // MARK: - firebase configurations
    func configDatabase() {
        ref = FIRDatabase.database().reference()
        ref.child("users/\(FIRAuth.auth()!.currentUser!.uid)/likes").observeSingleEvent(of: .childAdded, with: { (snapshot) in
            
        })
    }
}
