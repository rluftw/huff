//
//  HomeViewController.swift
//  huff
//
//  Created by Xing Hui Lu on 11/24/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HomeViewController: UIViewController {

    // MARK: - outlets
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var quoteAuthor: UILabel!
    
    @IBOutlet weak var topDistanceTable: UITableView!
    
    // MARK: - properties
    var topRecordHandle: FIRDatabaseHandle?
    var topRecords = [TopRunRecord]()
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check first time login and fetch global high score
        configureHomescreen()

        // fetch the remote configurations
        fetchQuotes()
    }
    
    
    // MARK: - actions
    @IBAction func startARun(_ sender: Any) {
        performSegue(withIdentifier: "beginRun", sender: self)
    }
    
    @IBAction func showRunHistory(_ sender: Any) {
        performSegue(withIdentifier: "showPastRuns", sender: self)
    }

    func fetchQuotes() {
        FirebaseService.sharedInstance().fetchQuotes { (quote, author) in
            guard let quote = quote, let author = author else {
                return
            }
            self.quoteLabel.text = "\"\(quote)\""
            self.quoteAuthor.text = "- \(author)"
        }
    }
    
    func configureHomescreen() {
        // check if this is the users first time logging in
        let accountHandler = FirebaseService.sharedInstance().fetchAccountNode { (localSnapshot) in
            guard let snapshot = localSnapshot.value as? [String: Any], let _ = snapshot["creation_date"] as? TimeInterval else {
                print("no creation date found - attempting to set a creation date")
                FirebaseService.sharedInstance().setAccountCreationDate()
                return
            }
        }
        FirebaseService.sharedInstance().removeObserver(handler: accountHandler)
        topRecordHandle = FirebaseService.sharedInstance().fetchGlobalHSDistance { (localSnapshot) in
            self.handleTopRecords(localSnapshot: localSnapshot)
        }
    }
    
    func handleTopRecords(localSnapshot: FIRDataSnapshot) {
        guard let snapshot = localSnapshot.value as? [String: Any] else {
            print("invalid snapshot format")
            return
        }
        let record = TopRunRecord(dict: snapshot)
        self.topRecords.insert(record, at: 0)
        self.topDistanceTable.reloadData()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topListCell", for: indexPath) as! TopListCell
        
        cell.rankLabel.text = "\(indexPath.row+1)."
        cell.userLabel.text = indexPath.row <= topRecords.count-1 ? topRecords[indexPath.row].username : "--------------"
        cell.valueLabel.text = indexPath.row <= topRecords.count-1 ? "\(String(format: "%.2f", topRecords[indexPath.row].distance/1609.34)) miles": "0.00 miles"
        
        return cell
    }
}
