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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - properties
    var activeRuns = [ActiveRun]()
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
        // prevents anymore updates from firing
        manager.stopUpdatingLocation()
        manager.delegate = nil
        
        fiveKTable.isUserInteractionEnabled = false
        if let location = locations.last {
            ActiveService.sharedInstance().search(location: location, completionHandler: { (result, error) in
                guard let results = result?["results"] as? [[String: AnyObject]] else {
                    print("there was a problem with the active service results")
                    return
                }
                for result in results {
                    // check registration status - only include runs that are still open for registration.
                    guard let registrationStatus = result["salesStatus"] as? String, registrationStatus == "registration-open" else {
                        continue
                    }
                    
                    if let run = ActiveRun(result: result) {
                        self.activeRuns.append(run)
                        print("\(run)\n\n")
                    }
                }
                
                print("\(self.activeRuns.count) runs")
                
                DispatchQueue.main.async {
                    self.fiveKTable.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.fiveKTable.isUserInteractionEnabled = true
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "activeRunCell", for: indexPath) as! ActiveRunTableViewCell
        cell.run = activeRuns[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeRuns.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
