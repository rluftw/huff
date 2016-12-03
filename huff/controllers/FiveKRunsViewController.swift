//
//  FiveKRunsViewController.swift
//  huff
//
//  Created by Xing Hui Lu on 12/1/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit
import CoreLocation

class FiveKRunsViewController: UIViewController, CLLocationManagerDelegate {
    // MARK: - outlets
    @IBOutlet weak var fiveKTable: UITableView! {
        didSet {
            fiveKTable.delegate = self
            fiveKTable.dataSource = self
            fiveKTable.rowHeight = UITableViewAutomaticDimension
            fiveKTable.estimatedRowHeight = 150
        }
    }
    
    // MARK: - properties
    var ActiveRuns = [ActiveRun]()
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        return lm
    }()
    
    // MARK: - computed properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.requestWhenInUseAuthorization()
    }
    
    
    // MARK: - CLLocationDelegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            ActiveService.sharedInstance().search(location: location, completionHandler: { (result, error) in
                guard let results = result?["results"] as? [[String: AnyObject]] else {
                    print("there was a problem with the active service results")
                    return
                }
                
                for result in results {
                    let organizationDict = result["organization"] as? [String: AnyObject]
                    
                    let organization = RunOrganization(organizationDict: organizationDict)
                    print("\(organization)\n\n")
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse: manager.requestLocation()
        case .denied: break
        default: break
        }
    }
}

extension FiveKRunsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activeRunCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}
