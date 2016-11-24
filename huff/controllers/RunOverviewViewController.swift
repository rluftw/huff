//
//  RunOverviewViewController.swift
//  huff
//
//  Created by Xing Hui Lu on 11/24/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit
import MapKit

class RunOverviewViewController: UIViewController {

    // MARK: - properties
    var run: Run!
    
    // MARK: - computed properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMap()
    }

    // MARK: - actions
    @IBAction func done(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - helper methods
    func setupMap() {
        
    }
}
