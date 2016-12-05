//
//  ActiveRunDetailViewController.swift
//  huff
//
//  Created by Xing Hui Lu on 12/3/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit

class ActiveRunDetailViewController: UIViewController {

    // MARK: - properties
    var run: ActiveRun!
    
    // MARK: - computed properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
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
        
        updateLabels()
    }
    
    // MARK: - helper methods
    func updateLabels() {
        organizationName?.text = run.organization.name
        runName?.text = run.name
        runDescription?.text = run.runDescription
        let formatter = DateFormatter()
        
        formatter.dateStyle = .short
        
        if let dateRun = run.runDate {
            runDate?.text = "Run on: " + formatter.string(from: dateRun)
        }
        
        if let _ = run.organization.phone, UIDevice.current.model == "iPhone" {
            contactButton.isHidden = false
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
}
