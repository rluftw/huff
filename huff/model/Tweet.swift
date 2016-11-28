//
//  Tweet.swift
//  huff
//
//  Created by Xing Hui Lu on 11/25/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import Foundation
import UIKit

struct Tweet {
    var message: String
    let username: String
    var photoURLs: [String]?
    
    init(tweetDict: [String: AnyObject]) {        
        let userDict = tweetDict["user"] as? [String: AnyObject]
        self.username = userDict?["screen_name"] as? String ?? "N/A"
        self.message = tweetDict["text"] as? String ?? "N/A"
        
         // remove all photo links from the message text, and add them to an array of photo urls
        if let entitiesDict = tweetDict["extended_entities"] as? [String: AnyObject], let medias = entitiesDict["media"] as? [[String: AnyObject]] {
            self.photoURLs = [String]()
            for media in medias {
                guard let url = media["url"] as? String, let type = media["type"] as? String, type == "photo", let mediaURL = media["media_url_https"] as? String else {
                    print("something was not good")
                    break
                }
                if let range = message.range(of: url) {
                    self.message.removeSubrange(range)
                }
                self.photoURLs!.append(mediaURL)
             }
        }
    }
}
