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
}
