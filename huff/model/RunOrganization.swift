//
//  RunOrganization.swift
//  huff
//
//  Created by Xing Hui Lu on 12/2/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import Foundation

class RunOrganization: CustomStringConvertible {
    let organizationPrimaryContact: String?
    let organizationName: String?
    let organizationAddress1: String?
    let organizationCity: String?
    let organizationState: String?
    let organizationPhone: String?
    
    var description: String {
        return "Primary Contact: \(organizationPrimaryContact ?? "N/A")\nOrganization: \(organizationName ?? "N/A")\nAddress:\n\(organizationAddress1 ?? "N/A")\n\(organizationCity ?? "N/A"), \(organizationState ?? "N/A")\nPhone: \(organizationPhone ?? "N/A")"
    }
    
    init(organizationDict: [String: AnyObject]?) {
        organizationPrimaryContact = organizationDict?["primaryContactName"] as? String
        organizationName = organizationDict?["organizationName"] as? String
        organizationAddress1 = organizationDict?["addressLine1Txt"] as? String
        organizationCity = organizationDict?["addressCityName"] as? String
        organizationState = organizationDict?["addressStateProvinceCode"] as? String
        organizationPhone = organizationDict?["primaryContactPhone"] as? String
    }
}
