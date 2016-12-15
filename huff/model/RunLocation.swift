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
    
    init?(result: [String: AnyObject]) {
        guard let runLocation = result["place"] as? [String: AnyObject] else {
            return nil
        }
        
        placeName = runLocation["placeName"] as? String
        address1 = runLocation["addressLine1Txt"] as? String
        city = runLocation["cityName"] as? String
        state = runLocation["stateProvinceCode"] as? String
        zip = runLocation["postalCode"] as? String
    }
    
    func toDict() -> [String: Any] {
        var dict = [String: Any]()
        
        if let runPlaceName = self.placeName { dict["run_location_name"] = runPlaceName }
        if let runAddress1 = self.address1 { dict["run_address1"] = runAddress1 }
        if let runCity = self.city { dict["run_city"] = runCity }
        if let runState = self.state { dict["run_state"] = runState }
        if let runZip = self.zip { dict["run_zip"] = runZip }
        
        return dict
    }
}

extension RunLocation: Equatable {
    static func ==(lhs: RunLocation, rhs: RunLocation) -> Bool {
        return lhs.placeName == rhs.placeName && lhs.address1 == rhs.address1 && lhs.city == rhs.city && lhs.state == rhs.state && lhs.zip == rhs.zip
    }
}
