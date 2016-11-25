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
    var run: Run!
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
        mapView.delegate = self
        
        if self.run.locations.count > 0 {
            print("setting map up")
            mapView.region = mapRegion!
            mapView.add(polyLine!)
        }
    }
    
    // MARK: - map delegate methods
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let overlay = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        print("adding polyline")
        
        let polyLineRenderer = MKPolylineRenderer(polyline: overlay)
        polyLineRenderer.strokeColor = UIColor(red: 1, green: 193/255.0, blue: 0, alpha: 1.0)
        polyLineRenderer.lineWidth = 3
        
        return polyLineRenderer
    }
    
}
