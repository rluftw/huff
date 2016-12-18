//
//  RunOverviewViewController.swift
//  huff
//
//  Created by Xing Hui Lu on 11/24/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class RunOverviewViewController: UIViewController, MKMapViewDelegate {

    // MARK: - properties
    var run: Run!
    var databaseRef: FIRDatabaseReference!
    lazy var mapRegion: MKCoordinateRegion? = {
        var mr = MKCoordinateRegion()
        guard let initialLocation = self.run.locations.last else {
            return nil
        }
        
        // calculate the initial min/max latitude
        var minLat = initialLocation.latitude
        var maxLat = initialLocation.latitude
        // calculate the initial min/max longitude
        var minLon = initialLocation.longitude
        var maxLon = initialLocation.longitude
        
        
        // iterate through the coordinates and check the longitude and latitude
        _ = self.run.locations.map { (location) in
            let lat = location.latitude
            let lon = location.longitude
            
            minLat = lat < minLat ? lat: minLat
            maxLat = lat > maxLat ? lat: maxLat
            minLon = lon < minLon ? lon: minLon
            maxLon = lon > maxLon ? lon: maxLon
        }
        
        mr.center.latitude = (minLat+maxLat)/2
        mr.center.longitude = (minLon+maxLon)/2
        
        // calculate the actual view of the map
        mr.span.latitudeDelta = (maxLat-minLat) * 1.5
        mr.span.longitudeDelta = (maxLon-minLon) * 1.5
        
        return mr
    }()
    
    lazy var polyLine: MKPolyline? = {
        var coordinates = [CLLocationCoordinate2D]()
        
        for location in self.run.locations {
            coordinates.append(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        }
        
        return MKPolyline(coordinates: coordinates, count: coordinates.count)
    }()
        
    // MARK: - outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMap()
        
        // setup firebase connections
        databaseRef = FIRDatabase.database().reference()
    }

    // MARK: - actions
    @IBAction func done(_ sender: Any) {
        // TODO: save data to firebase and check if the run has been longet than 5 minutes
        saveRun()
        
        let alertVC = UIAlertController(title: "Run", message: "Your run has been saved.", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Great!", style: .default, handler: { (action) in
            self.navigationController?.dismiss(animated: true, completion: nil)
        }))
        
        present(alertVC, animated: true, completion: nil)
    }
    
    // MARK: - helper methods
    func setupMap() {
        mapView.delegate = self
        
        if self.run.locations.count > 0 {
            mapView.region = mapRegion!
            mapView.add(polyLine!)
        }
    }
    
    // MARK: - map delegate methods
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let overlay = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let polyLineRenderer = MKPolylineRenderer(polyline: overlay)
        polyLineRenderer.strokeColor = UIColor(red: 1, green: 193/255.0, blue: 0, alpha: 1.0)
        polyLineRenderer.lineWidth = 3
        
        return polyLineRenderer
    }

    func saveRun() {
        databaseRef.child("users/\(FIRAuth.auth()!.currentUser!.uid)/personal_runs")
            .childByAutoId()
            .setValue(run.toDict())
    }
}
