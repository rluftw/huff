//
//  CurrentRunViewController.swift
//  huff
//
//  Created by Xing Hui Lu on 11/22/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit
import CoreLocation

fileprivate let metersInMiles = 1609.344

class CurrentRunViewController: UIViewController, CLLocationManagerDelegate {
    // MARK: - outlets
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    // MARK: - properties
    let run: Run = Run()
    var timer: Timer?
    
    // used to determine distance
    var locations: [CLLocation] = []
    
    // used for paused state
    var paused = false
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.desiredAccuracy = kCLLocationAccuracyBest
        lm.activityType = .fitness
        // lm.distanceFilter = 5
        lm.delegate = self
        return lm
    }()
    
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        dateLabel.text = "Today is: " + formatter.string(from: Date())
        
        // this request for location use
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopUpdatingLocation()
    }
    
    // MARK: - actions
    @IBAction func stopRun(_ sender: Any) {
        self.stopUpdatingLocation()
        
        endRunWithWarning(title: "Stop Run", message: "Are you sure you'd like to end this run?") {
            (action) in
            self.performSegue(withIdentifier: "showRunOverview", sender: self)
        }
    }
    
    
    @IBAction func pauseRun(_ sender: Any) {
        paused = !paused
        if paused {
            self.stopUpdatingLocation()
        } else {
            self.startUpdatingLocation()
        }
    
        pauseButton.setTitle(paused ? "RESUME": "PAUSE", for: .normal)
        pauseButton.backgroundColor = paused ? UIColor(red: 0, green: 153/255.0, blue: 0, alpha: 1.0): UIColor(red: 1, green: 193/255.0, blue: 0, alpha: 1.0)
    }
    
    @IBAction func cancelRun(_ sender: Any) {
        self.stopUpdatingLocation()
        
        endRunWithWarning(title: "Cancel Run", message: "Are you sure you'd like to cancel? All data recorded from this run will be deleted.") {
            (action) in
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    // MARK: - location manager delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            if newLocation.horizontalAccuracy < 20 {
                // update the distance if at least 1 location logged
                if self.locations.count > 0 {
                    print("distance: \(newLocation.distance(from: self.locations.last!))\naccuracy: \(newLocation.horizontalAccuracy)\n")
                    run.distance += newLocation.distance(from: self.locations.last!)
                    run.locations.append(Location(location: newLocation.coordinate))
                }
                self.locations.append(newLocation)
            } else {
                print("accuracy: \(newLocation.horizontalAccuracy)\n")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse: self.startUpdatingLocation()
        default: break
        }
    }
    
    
    // MARK: - selectors
    func eachSecond() {
        run.duration += 1
        let durationValues = determineDuration()
        timerLabel.text = "\(durationValues.hour):\(durationValues.min):\(durationValues.sec)"
        distanceLabel.text = String(format: "%.2f", run.distance/metersInMiles)
        paceLabel.text = determinePace()
    }
    
    // MARK: - helper methods
    func startUpdatingLocation() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(eachSecond), userInfo: nil, repeats: true)
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
    }
    
    func determineDuration() -> (hour: String, min: String, sec: String) {
        let minutes = Int(floor(run.duration/60))
        let hours = Int(floor(Double(minutes)/60.0))
        let seconds = Int(run.duration.truncatingRemainder(dividingBy: 60))
        let sHours = String(format: "%02d", hours)
        let sMinutes = String(format: "%02d", minutes%60)
        let sSeconds = String(format: "%02d", seconds)
        return (sHours, sMinutes, sSeconds)
    }
    
    func determinePace() -> String {
        guard run.duration != 0 && run.distance != 0 else {
            return "00:00"
        }
        let avgPaceSecMeters = (run.duration/run.distance)*metersInMiles
        let paceMin = Int(avgPaceSecMeters/60)
        let paceSec = Int(avgPaceSecMeters)-(paceMin*60)
        return String(format: "%02d:%02d ", paceMin, paceSec)
    }
    
    func endRunWithWarning(title: String, message: String, yesAction: @escaping (UIAlertAction) -> Void) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        // add the action for ending the run
        alertVC.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: yesAction))
        alertVC.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action) in
            self.startUpdatingLocation()
        }))
        
        present(alertVC, animated: true, completion: nil)
    }
    
    // MARK: - navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let runOverviewVC = segue.destination as? RunOverviewViewController {
            runOverviewVC.run = self.run
        }
    }
}


