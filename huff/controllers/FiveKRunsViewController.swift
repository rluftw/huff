//
//  FiveKRunsViewController.swift
//  huff
//
//  Created by Xing Hui Lu on 12/1/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit
import CoreLocation

class FiveKRunsViewController: UIViewController {
    // MARK: - outlets/views
    @IBOutlet weak var fiveKTable: UITableView! {
        didSet {
            fiveKTable.delegate = self
            fiveKTable.dataSource = self
            fiveKTable.rowHeight = UITableViewAutomaticDimension
            fiveKTable.estimatedRowHeight = 150
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    lazy var noResultBackgroundView: NoResultsTableViewBackground = {
        var bgv = NoResultsTableViewBackground(frame: self.fiveKTable.bounds)
        bgv.title = "No Five 5ks Available"
        return bgv
    }()
    
    // MARK: - properties
    var activeRuns = [ActiveRun]()
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        return lm
    }()
    
    // MARK: - actions
    @IBAction func refresh(_ sender: Any) {
        guard Reachability.isConnectedToNetwork() else {
            presentAlert(title: "Please check your connection", message: "")
            self.handleSearch(stop: true)
            return
        }
        activeRuns.removeAll(keepingCapacity: false)
        handleSearch(stop: false)
    }
        
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.requestWhenInUseAuthorization()
    }

    // MARK: - helper methods
    func search(radius: Int, location: CLLocation) {
        guard Reachability.isConnectedToNetwork() else {
            presentAlert(title: "Please check your connection", message: "")
            self.handleSearch(stop: true)
            return
        }
        ActiveService.sharedInstance().search(radius: radius, location: location, completionHandler: { (result, error) in
                guard let results = result?["results"] as? [[String: AnyObject]] else {
                    print("there was a problem with the active service results")
                    return
                }
                for result in results {
                    // check registration status - only include runs that are still open for registration.
                    guard let registrationStatus = result["salesStatus"] as? String, registrationStatus == "registration-open" else {
                        continue
                    }
                    
                    // create the array of runs available
                    if let run = ActiveRun(result: result) {
                        self.activeRuns.append(run)
                        DispatchQueue.main.async {
                            // use this instead of reload table to balance out ui update
                            self.fiveKTable.insertRows(at: [IndexPath(item: self.activeRuns.count-1, section: 0)], with: .automatic)
                        }
                    }
                }
                self.handleSearch(stop: true)
            })
    }
    
    
    // MARK: - helper methods
    fileprivate func handleSearch(stop: Bool) {
        DispatchQueue.main.async {
            // display no results for background view
            if stop {
                self.fiveKTable.backgroundView = self.activeRuns.count < 1 ? self.noResultBackgroundView: nil
            } else {
                self.fiveKTable.reloadData()
                self.fiveKTable.backgroundView = nil
                self.locationManager.delegate = self
                self.locationManager.requestLocation()
            }
            
            self.refreshButton.isEnabled = stop
            stop ? self.activityIndicator.stopAnimating(): self.activityIndicator.startAnimating()
            self.fiveKTable.isUserInteractionEnabled = stop
        }
    }
}

extension FiveKRunsViewController: CLLocationManagerDelegate {
    // MARK: - CLLocationDelegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // prevents anymore updates from firing
        manager.stopUpdatingLocation()
        manager.delegate = nil
        
        fiveKTable.isUserInteractionEnabled = false
        if let location = locations.last {
            search(radius: 50, location: location)
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
    // MARK: - table view delegates/datasource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activeRunCell", for: indexPath) as! ActiveRunTableViewCell
        cell.run = activeRuns[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeRuns.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        // use the cell as the sender - used later to extract the active run object
        let cell = tableView.cellForRow(at: indexPath)
        performSegue(withIdentifier: "showRunDetail", sender: cell)
    }
    
}

extension FiveKRunsViewController {
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
