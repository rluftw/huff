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
        
        primaryContact = organizationDict[Key.ContactName] as? String
        name = organizationDict[Key.OrganizationName] as? String
        address1 = organizationDict[Key.Address1] as? String
        city = organizationDict[Key.City] as? String
        state = organizationDict[Key.State] as? String
        phone = organizationDict[Key.Phone] as? String
        zip = organizationDict[Key.Postal] as? String
    }
    
    func toDict() -> [String: Any] {
        var dict = [String: Any]()
        
        if let name = self.name { dict[Key.OrganizationName] = name }
        if let address1 = self.address1 { dict[Key.Address1] = address1 }
        if let contact = self.primaryContact { dict[Key.ContactName] = contact }
        if let city = self.city { dict[Key.City] = city }
        if let state = self.state { dict[Key.State] = state }
        if let phone = self.phone { dict[Key.Phone] = phone }
        if let zip = self.zip { dict[Key.Postal] = zip }
        
        return dict
    }
}

extension RunOrganization: Equatable {
    static func ==(lhs: RunOrganization, rhs: RunOrganization) -> Bool {
        return lhs.primaryContact == rhs.primaryContact && lhs.name == rhs.name && lhs.address1 == rhs.address1 && lhs.city == rhs.city && lhs.state == rhs.state && lhs.phone == rhs.phone && lhs.zip == rhs.zip
    }
}

extension RunOrganization {
    struct Key {
        static let ContactName = "primaryContactName"
        static let OrganizationName = "organizationName"
        static let Address1 = "addressLine1Txt"
        static let City = "addressCityName"
        static let State = "addressStateProvinceCode"
        static let Phone = "primaryContactPhone"
        static let Postal = "addressPostalCd"
    }
}
