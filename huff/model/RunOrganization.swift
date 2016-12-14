//
//  RunOrganization.swift
//  huff
//
//  Created by Xing Hui Lu on 12/2/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import Foundation

class RunOrganization: CustomStringConvertible {
    let primaryContact: String?
    let name: String?
    let address1: String?
    let city: String?
    let state: String?
    let phone: String?
    let zip: String?
    
    var description: String {
        return "Primary Contact: \(primaryContact ?? "N/A")\nOrganization: \(name ?? "N/A")\nAddress:\n\t\(address1 ?? "N/A")\n\t\(city ?? "N/A"), \(state ?? "N/A")\n\tPhone: \(phone ?? "N/A")"
    }
    
    init?(result: [String: AnyObject]) {
        // there must be an organization dictionary
        guard let organizationDict = result["organization"] as? [String: AnyObject] else {
            print("there was a problem with the active service results")
            return nil
        }
        
        primaryContact = organizationDict["primaryContactName"] as? String
        name = organizationDict["organizationName"] as? String
        address1 = organizationDict["addressLine1Txt"] as? String
        city = organizationDict["addressCityName"] as? String
        state = organizationDict["addressStateProvinceCode"] as? String
        phone = organizationDict["primaryContactPhone"] as? String
        zip = organizationDict["addressPostalCd"] as? String
    }
}

extension RunOrganization: Equatable {
    static func ==(lhs: RunOrganization, rhs: RunOrganization) -> Bool {
        return lhs.primaryContact == rhs.primaryContact && lhs.name == rhs.name && lhs.address1 == rhs.address1 && lhs.city == rhs.city && lhs.state == rhs.state && lhs.phone == rhs.phone && lhs.zip == rhs.zip
    }
}
