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
    let timestamp: TimeInterval
    var userUID: String!
    
    var locations: [Location] = []
    
    init(uid: String) {
        timestamp = NSDate().timeIntervalSince1970
        duration = 0
        distance = 0
        userUID = uid
    }
    
    init(dict: [String: Any]) {
        self.duration = dict[Key.Duration] as! Double
        self.distance = dict[Key.Distance] as! Double
        self.timestamp = dict[Key.Timestamp] as! TimeInterval
        self.userUID = dict[Key.UID] as! String
    }
    
    func toDict() -> [String: Any] {
        return [
            Key.Distance: self.distance,
            Key.Duration: self.duration,
            Key.Timestamp: self.timestamp,
            Key.UID: self.userUID
        ]
    }
}

extension Run {
    struct Key {
        static let Distance = "distance"
        static let Duration = "duration"
        static let Timestamp = "timestamp"
        static let UID = "user_uid"
    }
}
