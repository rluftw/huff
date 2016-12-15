//
//  ActiveRun.swift
//  huff
//
//  Created by Xing Hui Lu on 12/2/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import Foundation
import UIKit

class ActiveRun: CustomStringConvertible {
    let organization: RunOrganization!
    let location: RunLocation!
    let name: String?
    let logoURL: String?
    let assetID: String!
    var registrationURL: String?
    var runDate: Date?
    var registrationDeadlineDate: Date?
    var runDescription: String?
    
    
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
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let rawRunDate = result["activityStartDate"] as? String {
            runDate = formatter.date(from: rawRunDate)
        }
        if let rawRegistrationDeadline = result["salesEndDate"] as? String {
            registrationDeadlineDate = formatter.date(from: rawRegistrationDeadline)
        }
        
        self.assetID = result["assetGuid"] as! String
        
        if let descriptionArray = result["assetDescriptions"] as? [AnyObject] {
            for descriptionDict in descriptionArray {
                let htmlDescription = descriptionDict["description"] as? String
                let description = self.htmlToAttributedString(htmlString: htmlDescription)?.string
                if let trimmedDescription = description?.trimmingCharacters(in: .whitespacesAndNewlines) {
                    self.runDescription = trimmedDescription
                }
            }
        }
        
        self.registrationURL = result["urlAdr"] as? String
    }
    
    // MARK: - helper methods
    func htmlToAttributedString(htmlString: String?) -> NSAttributedString? {
        guard let htmlString = htmlString else { return nil }
        guard let data = htmlString.data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func toDict() -> [String: Any] {
        var dict = [String: Any]()
        
        let locationDict = self.location.toDict()
        let organizationDict = self.organization.toDict()
        
        if let runName = name { dict["run_name"] = runName }
        if let logoLink = logoURL { dict["run_logo"] = logoLink }
        if let id = assetID { dict["run_id"] = id }
        if let registrationLink = registrationURL { dict["registration_link"] = registrationLink }
        if let run_date = runDate?.timeIntervalSince1970 { dict["run_date"] = run_date }
        if let run_deadline = registrationDeadlineDate?.timeIntervalSince1970 { dict["run_deadline"] = run_deadline }
        if let run_description = runDescription { dict["run_description"] = run_description }

        
        locationDict.forEach { (key, value) in
            dict[key] = value
        }
        
        organizationDict.forEach { (key, value) in
            dict[key] = value
        }
        
        return dict
    }
}

extension ActiveRun: Equatable {
    // MARK: - allow the usage of identity operators
    static func ==(lhs: ActiveRun, rhs: ActiveRun) -> Bool {
        return lhs.assetID == rhs.assetID
    }
    
    static func ==(lhs: ActiveRun, rhs: [String: Any]) -> Bool {
        return self.compareRuns(lhs: lhs, rhs: rhs)
    }
    
    static func ==(lhs: [String: Any], rhs: ActiveRun) -> Bool {
        return self.compareRuns(lhs: rhs, rhs: lhs)
    }
    
    static func compareRuns(lhs: ActiveRun, rhs: [String: Any]) -> Bool {
        return lhs.assetID == rhs["run_id"] as! String
    }
}
