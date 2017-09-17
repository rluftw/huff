//
//  RankingsViewController.swift
//  huff
//
//  Created by Xing Hui Lu on 9/17/17.
//  Copyright © 2017 Xing Hui Lu. All rights reserved.
//

import UIKit
import FirebaseDatabase

class RankingsViewController: UIViewController {

    @IBOutlet weak var topDistanceTable: UITableView!
    
    // MARK: - properties
    var topRecordHandle: DatabaseHandle?
    var topRecords = [TopRunRecord]()
    
    // MARK: - initialization
    deinit {
        FirebaseService.sharedInstance().removeObserver(handler: topRecordHandle)
    }
    
    // MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // check first time login and fetch global high score
        configureHomescreen()
    }

    // MARK: - helpers
    
    private func configureHomescreen() {
        // check if this is the users first time logging in
        FirebaseService.sharedInstance().fetchAccountNode { (localSnapshot) in
            guard let snapshot = localSnapshot.value as? [String: Any], let _ = snapshot["creation_date"] as? TimeInterval else {
                print("no creation date found - attempting to set a creation date")
                FirebaseService.sharedInstance().setAccountCreationDate()
                return
            }
        }
        topRecordHandle = FirebaseService.sharedInstance().fetchGlobalHSDistance { (localSnapshot) in
            self.handleTopRecords(localSnapshot: localSnapshot)
        }
    }
    
    private func handleTopRecords(localSnapshot: DataSnapshot) {
        guard let snapshot = localSnapshot.value as? [String: Any] else {
            print("invalid snapshot format")
            return
        }
        let record = TopRunRecord(dict: snapshot)
        self.topRecords.insertOrdered(record)
        self.topDistanceTable.reloadData()
    }
}

extension RankingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topListCell", for: indexPath) as! TopListCell
        
        cell.rankLabel.text = "\(indexPath.row+1)."
        cell.userLabel.text = indexPath.row <= topRecords.count-1 ? topRecords[indexPath.row].username : "--------------"
        cell.valueLabel.text = indexPath.row <= topRecords.count-1 ? "\(String(format: "%.2f", topRecords[indexPath.row].distance/1609.34)) miles": "0.00 miles"
        
        return cell
    }
}
