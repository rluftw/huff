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
    
    override func draw(_ rect: CGRect) {

        // make the bottom, left, and right borders
        let bottomBorder = createLayerWithFrame(x: 0, y: frame.height-cellBorderWidth, width: frame.size.width, height: cellBorderWidth)
        let leftBorder = createLayerWithFrame(x: 0, y: 0, width: cellBorderWidth, height: frame.size.height)
        let rightBorder = createLayerWithFrame(x: frame.size.width-cellBorderWidth, y: 0, width: cellBorderWidth, height: frame.size.height)
        
        contentView.layer.addSublayer(bottomBorder)
        contentView.layer.addSublayer(leftBorder)
        contentView.layer.addSublayer(rightBorder)
    }
    
    // MARK: - helper methods
    
    func createLayerWithFrame(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> CALayer {
        let borderColor = UIColor(red: 40/255.0, green: 43/255.0, blue: 53/255.0, alpha: 1.0).cgColor
        let layer = CALayer()
        layer.borderColor = borderColor
        layer.borderWidth = cellBorderWidth
        layer.frame = CGRect(x: x, y: y, width: width, height: height)
        return layer
    }
}
