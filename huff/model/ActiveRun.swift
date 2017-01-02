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
    
    init?(result: [String: Any]?) {
        guard let result = result else {
            print("error - the parameter is invalid")
            return nil
        }
        // we must have an organization
        guard let organization = RunOrganization(result: result) else {
            print("error - the run has no organization key")
            return nil
        }
        // we also must have a location to run in
        guard let location = RunLocation(result: result) else {
            print("error - the run has no location")
            return nil
        }
        
        self.organization = organization
        self.location = location
        name = result[Key.Name] as? String
        logoURL = result[Key.LogoURL] as? String
        
        // extract the dates
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let rawRunDate = result[Key.ActivityStartDate] as? String {
            runDate = formatter.date(from: rawRunDate)
        } else if let rawRunDate = result[Key.ActivityStartDate] as? TimeInterval {
            runDate = Date(timeIntervalSince1970: rawRunDate)
        }
        

        
        if let rawRegistrationDeadline = result[Key.SalesEndDate] as? String {
            registrationDeadlineDate = formatter.date(from: rawRegistrationDeadline)
        }
        
        assetID = result[Key.AssetUID] as! String
        
        if let descriptionArray = result[Key.AssetDescriptionDict] as? [AnyObject] {
            for descriptionDict in descriptionArray {
                let htmlDescription = descriptionDict[Key.AssetDescription] as? String
                let description = htmlToAttributedString(htmlString: htmlDescription)?.string
                if let trimmedDescription = description?.trimmingCharacters(in: .whitespacesAndNewlines) {
                    runDescription = trimmedDescription
                }
            }
        } else {
            runDescription = result[Key.AssetDescription] as? String
        }
        
        registrationURL = result["urlAdr"] as? String
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
        
        let locationDict = location.toDict()
        let organizationDict = organization.toDict()
        
        if let runName = name { dict[Key.Name] = runName }
        if let logoLink = logoURL { dict[Key.LogoURL] = logoLink }
        if let id = assetID { dict[Key.AssetUID] = id }
        if let registrationLink = registrationURL { dict[Key.RegistrationURL] = registrationLink }
        if let run_date = runDate?.timeIntervalSince1970 { dict[Key.ActivityStartDate] = run_date }
        if let run_deadline = registrationDeadlineDate?.timeIntervalSince1970 { dict[Key.SalesEndDate] = run_deadline }
        if let run_description = runDescription {
            dict[Key.AssetDescription] = run_description
        }
        
        
        
        dict[Key.Location] = locationDict
        dict[Key.Organization] = organizationDict
        
        return dict
    }
}

extension ActiveRun: Equatable {
    // MARK: - allow the usage of identity operators
    static func ==(lhs: ActiveRun, rhs: ActiveRun) -> Bool {
        return lhs.assetID == rhs.assetID
    }
    
    static func ==(lhs: ActiveRun, rhs: [String: Any]) -> Bool {
        return compareRuns(lhs: lhs, rhs: rhs)
    }
    
    static func ==(lhs: [String: Any], rhs: ActiveRun) -> Bool {
        return compareRuns(lhs: rhs, rhs: lhs)
    }
    
    static func compareRuns(lhs: ActiveRun, rhs: [String: Any]) -> Bool {
        return lhs.assetID == rhs["run_id"] as! String
    }
}


extension ActiveRun {
    struct Key {
        static let Name = "assetName"
        static let LogoURL = "logoUrlAdr"
        static let ActivityStartDate = "activityStartDate"
        static let SalesEndDate = "salesEndDate"
        static let AssetUID = "assetGuid"
        static let AssetDescriptionDict = "assetDescriptions"
        static let AssetDescription = "description"
        static let RegistrationURL = "urlAdr"
        static let Location = "place"
        static let Organization = "organization"
    }
}
