//
//  PastRunViewController.swift
//  huff
//
//  Created by Xing Hui Lu on 12/20/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PastRunViewController: UIViewController {
    @IBOutlet weak var numberOfRunsLabel: UILabel!
    @IBOutlet weak var runsLabel: UILabel!
    @IBOutlet weak var historyTable: UITableView!

    // MARK: - properties
    var runs = [Run]()
    var personalRunHandle: FIRDatabaseHandle?
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchPersonalRun()
    }
    
    // MARK: - initialization
    deinit {
        FirebaseService.sharedInstance().removeObserver(handler: personalRunHandle)
    }
    
    // MARK: - firebase fetch
    func fetchPersonalRun() {
        personalRunHandle = FirebaseService.sharedInstance().fetchPersonalRuns { (localSnapshot) in
            guard let snapshot = localSnapshot.value as? [String: Any] else {
                return
            }
            for (_, value) in snapshot {
                if let runDict = value as? [String: Any] {
                    let run = Run(dict: runDict)
                    
                    // TODO: make this more efficient
                    self.runs.append(run)
                    
                    self.runs.sort(by: { $0.timestamp > $1.timestamp })
                    self.historyTable.reloadData()
                    self.numberOfRunsLabel.text = "\(self.runs.count)"
                }
            }
        }
        
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
