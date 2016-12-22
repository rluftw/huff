//
//  Run.swift
//  huff
//
//  Created by Xing Hui Lu on 11/22/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import Foundation
import CoreLocation

fileprivate let metersInMiles = 1609.344

class Run {
    var distance: Double    // in meters
    var duration: Double
    let timestamp: TimeInterval
    var userUID: String!
    
    var locations: [Location] = []
    
    // MARK: initialization
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
    
    // MARK: - helper methods
    func determineDuration() -> (hour: String, min: String, sec: String) {
        let minutes = Int(floor(duration/60))
        let hours = Int(floor(Double(minutes)/60.0))
        let seconds = Int(duration.truncatingRemainder(dividingBy: 60))
        let sHours = String(format: "%02d", hours)
        let sMinutes = String(format: "%02d", minutes%60)
        let sSeconds = String(format: "%02d", seconds)
        return (sHours, sMinutes, sSeconds)
    }
    
    func determinePace() -> String {
        guard duration != 0 && distance != 0 else {
            return "00:00"
        }
        let avgPaceSecMeters = (duration/distance)*metersInMiles
        let paceMin = Int(avgPaceSecMeters/60)
        let paceSec = Int(avgPaceSecMeters)-(paceMin*60)
        return String(format: "%02d:%02d", paceMin, paceSec)
    }
    
    func distanceInMiles() -> String {
        let stringDistance = String(format: "%.2f",distance/metersInMiles)
        return stringDistance
    }

    func dateString() -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }
}
