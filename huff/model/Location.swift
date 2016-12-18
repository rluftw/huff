//
//  Location.swift
//  huff
//
//  Created by Xing Hui Lu on 11/22/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import Foundation
import CoreLocation

class Location {
    let longitude: CLLocationDegrees
    let latitude: CLLocationDegrees
    
    let timestamp: TimeInterval
    
    init(location: CLLocationCoordinate2D) {
        timestamp = NSDate().timeIntervalSince1970
        
        latitude = location.latitude
        longitude = location.longitude
    }
}
