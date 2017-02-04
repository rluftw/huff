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
    // MARK: - properties
    var distance: Double    // in meters
    var duration: Double
    let timestamp: TimeInterval
    var userUID: String!
    
    var locations: [Location] = []
    
    // MARK: - computed properties
    var shouldSave: Bool {
        return distance > 5
    }
    
    
    // MARK: initialization
    init(uid: String) {
        timestamp = NSDate().timeIntervalSince1970
        duration = 0
        distance = 0
        userUID = uid
    }
    
    init(dict: [String: Any]) {
        duration = dict[Key.Duration] as! Double
        distance = dict[Key.Distance] as! Double
        timestamp = dict[Key.Timestamp] as! TimeInterval
        userUID = dict[Key.UID] as! String
    }
    
    func toDict()->[String: Any] {
        return [
            Key.Distance: distance,
            Key.Duration: duration,
            Key.Timestamp: timestamp,
            Key.UID: userUID
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
    
    func determinePaceString() -> String {
        guard duration != 0 && distance != 0 else {
            return "00:00"
        }
        let avgPaceSecMeters = (duration/distance)*metersInMiles
        let paceMin = Int(avgPaceSecMeters/60)
        let paceSec = Int(avgPaceSecMeters)-(paceMin*60)
        return String(format: "%02d:%02d", paceMin, paceSec)
    }
    
    func determinePace() -> (Int, Int) {
        guard duration != 0 && distance != 0 else {
            return (0,0)
        }
        let avgPaceSecMeters = (duration/distance)*metersInMiles
        let paceMin = Int(avgPaceSecMeters/60)
        let paceSec = Int(avgPaceSecMeters)-(paceMin*60)
        return (paceMin, paceSec)
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
    
    static func distanceInMiles(meters: Double) -> Double {
        return meters/metersInMiles
    }
}


extension Run: Comparable {
    public static func ==(lhs: Run, rhs: Run) -> Bool {
        return lhs.timestamp == rhs.timestamp
    }

    public static func <(lhs: Run, rhs: Run) -> Bool {
        return lhs.timestamp < rhs.timestamp
    }
    
    public static func >(lhs: Run, rhs: Run) -> Bool {
        return lhs.timestamp > rhs.timestamp
    }
    
    public static func <=(lhs: Run, rhs: Run) -> Bool {
        return lhs.timestamp <= rhs.timestamp
    }
    
    public static func >=(lhs: Run, rhs: Run) -> Bool {
        return lhs.timestamp >= rhs.timestamp
    }
}

extension Run: CustomStringConvertible {
    var description: String {
        return "\(timestamp)"
    }
}
