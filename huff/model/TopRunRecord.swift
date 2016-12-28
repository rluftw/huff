//
//  TopRunRecord.swift
//  huff
//
//  Created by Xing Hui Lu on 12/18/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import Foundation

class TopRunRecord: CustomStringConvertible {
    let distance: Double
    let username: String
    
    var description: String {
        return "\(username) - \(distance)"
    }
    
    init(dict: [String: Any]) {
        distance = dict["distance"] as! Double
        username = dict["username"] as! String
    }
}

extension TopRunRecord: Comparable {
    public static func ==(lhs: TopRunRecord, rhs: TopRunRecord) -> Bool {
        return lhs.distance == rhs.distance
    }
    
    public static func <(lhs: TopRunRecord, rhs: TopRunRecord) -> Bool {
        return lhs.distance < rhs.distance
    }
    
    public static func >(lhs: TopRunRecord, rhs: TopRunRecord) -> Bool {
        return lhs.distance > rhs.distance
    }
    
    public static func <=(lhs: TopRunRecord, rhs: TopRunRecord) -> Bool {
        return lhs.distance <= rhs.distance
    }
    
    public static func >=(lhs: TopRunRecord, rhs: TopRunRecord) -> Bool {
        return lhs.distance >= rhs.distance
    }
}
