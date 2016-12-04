//
//  ActiveRun.swift
//  huff
//
//  Created by Xing Hui Lu on 12/2/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import Foundation

class ActiveRun: CustomStringConvertible {
    let organization: RunOrganization!
    let location: RunLocation!
    let name: String?
    let logoURL: String?
    var runDate: Date?
    var registrationDeadlineDate: Date?
    
    var description: String {
        guard let location = location, let organization = organization else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return "\(name ?? "Run Name N/A")\nlocation:\n==========\n\(location)\n\norganization\n==========\n\(organization)\n\(formatter.string(from: runDate!))"
    }
    
    init?(result: [String: AnyObject]?) {
        guard let result = result else {
            return nil
        }
        // we must have an organization
        guard let organization = RunOrganization(result: result) else {
            return nil
        }
        // we also must have a location to run in
        guard let location = RunLocation(result: result) else {
            return nil
        }
        self.organization = organization
        self.location = location
        self.name = result["assetName"] as? String
        self.logoURL = result["logoUrlAdr"] as? String
        
        // extract the dates
        let formatter = DateFormatter()
        // let calendar = Calendar.current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let rawRunDate = result["activityStartDate"] as? String {
            runDate = formatter.date(from: rawRunDate)
        }
        if let rawRegistrationDeadline = result["salesEndDate"] as? String {
            registrationDeadlineDate = formatter.date(from: rawRegistrationDeadline)
        }
    }
}
