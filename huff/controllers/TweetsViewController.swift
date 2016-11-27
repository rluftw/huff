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
    var tweets = [Tweet]()
    lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return rc
    }()
    
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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetsTable.addSubview(refreshControl)
        
        performSearch()
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
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(translationX: -700, y: 0)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: { () -> Void in
            cell.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    // MARK: - helper methods
    
    fileprivate func performSearch() {
        TwitterService.sharedInstance().search { (result, error) in
            guard let result = result else {
                self.handleStopSearch()
                return
            }
            self.extractResults(result: result)
        }
    }
    
    fileprivate func extractResults(result: [String: AnyObject]) {
        if let statuses = result["statuses"] as? [[String: AnyObject]] {
            for status in statuses {
                let userDict = status["user"] as? [String: AnyObject]
                let user = userDict?["screen_name"] as? String ?? "N/A"
                var message = status["text"] as? String ?? "N/A"
                var photoURLs: [String]?
                
                // remove all photo links from the message text, and add them to an array of photo urls
                if let entitiesDict = status["entities"] as? [String: AnyObject], let medias = entitiesDict["media"] as? [[String: AnyObject]] {
                    photoURLs = [String]()
                    for media in medias {
                        guard let url = media["url"] as? String, let type = media["type"] as? String, type == "photo" else {
                            break
                        }
                        print("url: \(url)")
                        
                        if let range = message.range(of: url) {
                            message.removeSubrange(range)
                        }
                        photoURLs?.append(url)
                    }
                }
                
                self.tweets.append(Tweet(message: message, username: user, photoURLs: photoURLs))
            }
        }
        self.handleStopSearch()
    }
    
    
    fileprivate func handleStopSearch() {
        DispatchQueue.main.async {
            self.tweetsTable.reloadData()
            self.activityIndicator.stopAnimating()
            self.refreshControl.endRefreshing()
        }
    }
    
    func handleRefresh(_ refresh: UIRefreshControl) {
        self.tweets.removeAll(keepingCapacity: false)
        performSearch()
    }
}

