//
//  TweetsViewController.swift
//  huff
//
//  Created by Xing Hui Lu on 11/25/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {
    
    // MARK: - properties
    var tweets = [Tweet]()
    lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return rc
    }()
        
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
        self.view.isUserInteractionEnabled = false
        tweetsTable.addSubview(refreshControl)
        performSearch()
    }

    // MARK: - helper methods
    
    fileprivate func performSearch() {
        TwitterService.sharedInstance().search { (result, error) in
            guard let result = result else {
                self.handleStopSearch()
                return
            }
            // self.extractResults(result: result)
            if let tweets = result["statuses"] as? [[String: AnyObject]] {
                for tweet in tweets {
                    self.tweets.append(Tweet(tweetDict: tweet))
                }
            }
            self.handleStopSearch()
        }
    }
    
    fileprivate func handleStopSearch() {
        DispatchQueue.main.async {
            self.tweetsTable.reloadData()
            self.activityIndicator.stopAnimating()
            self.refreshControl.endRefreshing()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func handleRefresh(_ refresh: UIRefreshControl) {
        self.view.isUserInteractionEnabled = false
        self.tweets.removeAll(keepingCapacity: false)
        self.tweetsTable.reloadData()
        performSearch()
    }
}

extension TweetsViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - tableview datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tweet = self.tweets[indexPath.row]
        let cell: TweetTableViewCell!
        
        cell = tableView.dequeueReusableCell(withIdentifier: "regularTweetCell", for: indexPath)  as! RegularTweetTableViewCell
        
        cell.tweet = tweet
        return cell
    }
    
    
    // MARK: - tableview delegate
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(translationX: -700, y: 0)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: { () -> Void in
            cell.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tweet = tweets[indexPath.row]
        guard let photoURLS = tweet.photoURLs else {
            return
        }

        performSegue(withIdentifier: "showPhotos", sender: self)
        // TODO: pass the photoURLS to tweet images view controller
    }
    
}
