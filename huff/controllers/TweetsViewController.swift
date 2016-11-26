//
//  TweetsViewController.swift
//  huff
//
//  Created by Xing Hui Lu on 11/25/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - properties
    // var tweets = [Tweet]()
    
    // TEMP - for testing
    var tweets = [
        Tweet(message: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo", username: "someusername", photoURLs: nil),
        Tweet(message: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et ma", username: "someusername", photoURLs: [UIImage(named: "tweets")!]),
        Tweet(message: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis", username: "someusername", photoURLs: [UIImage(named: "tweets")!]),
        Tweet(message: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit.", username: "someusername", photoURLs: [UIImage(named: "tweets")!]),
        Tweet(message: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo", username: "someusername", photoURLs: nil),
        Tweet(message: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et ma", username: "someusername", photoURLs: [UIImage(named: "tweets")!]),
        Tweet(message: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis", username: "someusername", photoURLs: [UIImage(named: "tweets")!]),
        Tweet(message: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit.", username: "someusername", photoURLs: [UIImage(named: "tweets")!]),
        Tweet(message: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo", username: "someusername", photoURLs: nil),
        Tweet(message: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et ma", username: "someusername", photoURLs: [UIImage(named: "tweets")!]),
        Tweet(message: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis", username: "someusername", photoURLs: [UIImage(named: "tweets")!]),
        Tweet(message: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit.", username: "someusername", photoURLs: [UIImage(named: "tweets")!])
    ]
    
    
    // MARK: - computed properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - outlets
    @IBOutlet weak var tweetsTable: UITableView! {
        didSet {
            tweetsTable.dataSource = self
            tweetsTable.delegate = self
            tweetsTable.rowHeight = UITableViewAutomaticDimension
            tweetsTable.estimatedRowHeight = 150
        }
    }
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    // MARK: - tableview datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath)  as! TweetTableViewCell
        cell.tweet = self.tweets[indexPath.row]
        return cell
    }
    
    
    // MARK: - tableview delegate
    /*func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(translationX: -700, y: 0)
        UIView.animate(withDuration: 0.10, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: { () -> Void in
            cell.transform = CGAffineTransform.identity
        }, completion: nil)
    }*/
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
