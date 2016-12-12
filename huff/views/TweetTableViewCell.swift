//
//  RegularTweetTableViewCell.swift
//  huff
//
//  Created by Xing Hui Lu on 11/27/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    // MARK: - outlets
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tapForPhotosLabel: UILabel!
    
    // MARK: - properties
    var tweet: Tweet! {
        didSet {
            tweetText.text = tweet.message
            username.text = tweet.username
            
            // gather the date
            let date = Date(timeIntervalSince1970: tweet.dateCreated)
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            dateLabel.text = formatter.string(from: date)
            tapForPhotosLabel.isHidden = (tweet.photoURLs?.count ?? 0) > 0 ? false: true
        }
    }
    
}
