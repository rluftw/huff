//
//  Run.swift
//  huff
//
//  Created by Xing Hui Lu on 11/22/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import Foundation
import CoreLocation

class Run {
    var distance: Double    // in meters
    var duration: Double
    let timestamp: Double
    
    var locations: [Location] = []
    
    init() {
        timestamp = NSDate().timeIntervalSince1970
        duration = 0
        distance = 0
    }
}
