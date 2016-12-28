//
//  RunOverviewViewController.swift
//  huff
//
//  Created by Xing Hui Lu on 11/24/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit
import MapKit

class RunOverviewViewController: UIViewController, MKMapViewDelegate {

    // MARK: - properties
    var runCollection: RunCollection!
    lazy var mapRegion: MKCoordinateRegion? = {
        var mr = MKCoordinateRegion()
        guard let initialLocation = self.runCollection.currentRun.locations.last else {
            return nil
        }
        
        // calculate the initial min/max latitude
        var minLat = initialLocation.latitude
        var maxLat = initialLocation.latitude
        // calculate the initial min/max longitude
        var minLon = initialLocation.longitude
        var maxLon = initialLocation.longitude
        
        
        // iterate through the coordinates and check the longitude and latitude
        _ = self.runCollection.currentRun.locations.map { (location) in
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
        
        for location in self.runCollection.currentRun.locations {
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
    }

    // MARK: - actions
    @IBAction func done(_ sender: Any) {
        guard runCollection.currentRun.shouldSave else {
            presentAlert(message: "Run will not be saved due - less than 5 meters ran")
            return
        }
        
        saveRun()
        presentAlert(message: "Your run has been saved.")
    }
    
    // MARK: - helper methods
    func setupMap() {
        mapView.delegate = self
        
        if self.runCollection.currentRun.locations.count > 0 {
            mapView.region = mapRegion!
            mapView.add(polyLine!)
        }
    }
    
    func presentAlert(message: String) {
        let alertVC = UIAlertController(title: "Run", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
            self.navigationController?.dismiss(animated: true, completion: nil)
        }))
        
        present(alertVC, animated: true, completion: nil)
    }
    
    // MARK: - map delegate methods
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let overlay = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let polyLineRenderer = MKPolylineRenderer(polyline: overlay)
        polyLineRenderer.strokeColor = UIColor(red: 0, green: 122/255.0, blue: 1.0, alpha: 1)
        polyLineRenderer.lineWidth = 3
        
        return polyLineRenderer
    }

    // MARK: - firebase methods
    func saveRun() {
        // save run to personal node
        FirebaseService.sharedInstance().saveRun(run: runCollection.currentRun)
        
        // save total distance to global
        FirebaseService.sharedInstance().saveDistanceToGlobal()
        
        // check if we should update best distance
        if runCollection.shouldUpdateBestDistance {
            FirebaseService.sharedInstance().updateBestDistance(distance: runCollection.currentRun.distance)
        }
        
        // check if we should update best pace
        if runCollection.shouldUpdateBestPace {
            FirebaseService.sharedInstance().updateBestPace(run: runCollection.currentRun)
        }
    }
}
