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
        if let descriptionArray = result["assetDescriptions"] as? [AnyObject] {
            for descriptionDict in descriptionArray {
                let htmlDescription = descriptionDict["description"] as? String
                let description = self.htmlToAttributedString(htmlString: htmlDescription)?.string
                if let trimmedDescription = description?.trimmingCharacters(in: .whitespacesAndNewlines) {
                    self.runDescription = trimmedDescription
                }
            }
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
}

extension ActiveRun: Equatable {
    static func ==(lhs: ActiveRun, rhs: ActiveRun) -> Bool {
        return lhs.organization == rhs.organization && lhs.location == rhs.location && lhs.name == rhs.name && lhs.logoURL == rhs.logoURL &&
        lhs.registrationURL == rhs.registrationURL && lhs.runDate == rhs.runDate && lhs.registrationDeadlineDate == rhs.registrationDeadlineDate && lhs.runDescription == rhs.runDescription
    }
}
