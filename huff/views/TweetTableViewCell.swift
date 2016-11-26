//
//  TweetTableViewCell.swift
//  huff
//
//  Created by Xing Hui Lu on 11/25/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit

fileprivate let cellBorderWidth: CGFloat = 8

class TweetTableViewCell: UITableViewCell {

    // MARK: - outlets
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    
    // MARK: - properties
    var tweet: Tweet! {
        didSet {
            tweetText.text = tweet.message
            username.text = tweet.username
        }
    }
}
