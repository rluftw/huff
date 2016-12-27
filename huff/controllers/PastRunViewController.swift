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
                    
                    self.insertRunToCollection(run: run)
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
    
    // MARK: - helper methods
    func insertRunToCollection(run: Run) {
        let index = runs.findIndexToInsert(item: run, lo: 0, hi: runs.count-1)
        runs.insert(run, at: index)
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


// MARK: - array extension

// This method allows the use of O(logn) insertion while maintaining a sorted array
// The underlying logic is a binary search
extension Array where Element:Comparable {
    func findIndexToInsert(item: Element, lo: Int, hi: Int) -> Int {
        let mid = (hi+lo)/2
        // low must be less to hi
        guard lo <= hi else {
            return lo
        }
        // if there's an identical item in the array
        guard self[mid] != item else {
            return mid
        }
        return findIndexToInsert(item: item, lo: self[mid] > item ? mid+1: lo, hi: self[mid] < item ? mid-1: hi)
    }
}
