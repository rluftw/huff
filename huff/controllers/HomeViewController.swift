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
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
}
