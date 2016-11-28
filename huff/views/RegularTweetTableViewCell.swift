//
//  RegularTweetTableViewCell.swift
//  huff
//
//  Created by Xing Hui Lu on 11/27/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit

class RegularTweetTableViewCell: TweetTableViewCell {

    // MARK: - outlets
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    
    // MARK: - properties
    override var tweet: Tweet! {
        didSet {
            tweetText.text = tweet.message
            username.text = tweet.username
        }
    }
    
}
