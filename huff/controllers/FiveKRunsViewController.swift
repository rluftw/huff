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

    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        return lm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            ActiveService.sharedInstance().search(location: location, completionHandler: { (result, error) in
                print(result)
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
