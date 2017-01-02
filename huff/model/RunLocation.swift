//
//  RunLocation.swift
//  huff
//
//  Created by Xing Hui Lu on 12/3/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import Foundation

class RunLocation: CustomStringConvertible {
    let placeName: String?
    let address1: String?
    let city: String?
    let state: String?
    let zip: String?
    
    var description: String {
        return "\(placeName ?? "Place Name N/A")\n\(address1 ?? "N/A")\n\(city ?? "N/A"), \(state ?? "N/A") \(zip ?? "N/A")"
    }
    
    init?(result: [String: Any]) {
        guard let runLocation = result[Key.Place] as? [String: AnyObject] else {
            print("run location key is incorrect")
            return nil
        }
        
        placeName = runLocation[Key.PlaceName] as? String
        address1 = runLocation[Key.Address1] as? String
        city = runLocation[Key.City] as? String
        state = runLocation[Key.State] as? String
        zip = runLocation[Key.Postal] as? String
    }
    
    func toDict() -> [String: Any] {
        var dict = [String: Any]()
        
        if let runPlaceName = placeName { dict[Key.PlaceName] = runPlaceName }
        if let runAddress1 = address1 { dict[Key.Address1] = runAddress1 }
        if let runCity = city { dict[Key.City] = runCity }
        if let runState = state { dict[Key.State] = runState }
        if let runZip = zip { dict[Key.Postal] = runZip }
        
        return dict
    }
}

extension RunLocation: Equatable {
    static func ==(lhs: RunLocation, rhs: RunLocation) -> Bool {
        return lhs.placeName == rhs.placeName && lhs.address1 == rhs.address1 && lhs.city == rhs.city && lhs.state == rhs.state && lhs.zip == rhs.zip
    }
}

extension RunLocation {
    struct Key {
        static let Place = "place"
        static let PlaceName = "placeName"
        static let Address1 = "addressLine1Txt"
        static let City = "cityName"
        static let Postal = "postalCode"
        static let State = "stateProvinceCode"
    }
}
