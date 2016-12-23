//
//  PastRunViewController.swift
//  huff
//
//  Created by Xing Hui Lu on 12/20/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit
import Firebase

class PastRunViewController: UIViewController {
    @IBOutlet weak var numberOfRunsLabel: UILabel!
    @IBOutlet weak var runsLabel: UILabel!
    @IBOutlet weak var historyTable: UITableView!

    // MARK: - properties
    var databaseRef: FIRDatabaseReference?
    var addChildHandle: FIRDatabaseHandle?
    var runs = [Run]()
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureDatabase()
    }
    
    // MARK: - initialization
    deinit {
        databaseRef?.removeAllObservers()
    }
    
    // MARK: - firebase setup
    func configureDatabase() {
        databaseRef = FIRDatabase.database().reference()
        addChildHandle = databaseRef?.child("users/\(FIRAuth.auth()!.currentUser!.uid)/personal_runs")
            .queryOrdered(byChild: "timestamp")
            .observe(.childAdded, with: { (localSnapshot) in
            guard let snapshot = localSnapshot.value as? [String: Any] else {
                return
            }
            
            for (_, value) in snapshot {
                if let runDict = value as? [String: Any] {
                    let run = Run(dict: runDict)
                    self.runs.append(run)
                    
                    // TODO: implement it as a priority queue later on
                    self.runs.sort(by: { $0.timestamp > $1.timestamp })
                    self.historyTable.reloadData()
                    self.numberOfRunsLabel.text = "\(self.runs.count)"
                }
            }
            
        })
    }
    
    // MARK: - actions
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}


extension PastRunViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - table delegation methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return runs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pastRunCell", for: indexPath) as! PastRunTableViewCell
        cell.run = runs[indexPath.row]
        return cell
    }
}
