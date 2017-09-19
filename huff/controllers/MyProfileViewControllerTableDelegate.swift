//
//  MyProfileViewControllerTableDelegate.swift
//  huff
//
//  Created by Xing Hui Lu on 12/27/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit

extension MyProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profile?.favoriteActiveRuns.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activeRunCell", for: indexPath) as! ActiveRunTableViewCell
        cell.run = self.profile?.favoriteActiveRuns[indexPath.row]
        
        // assign a long hold gesture to add more options
        let longHoldGesture = UILongPressGestureRecognizer(target: self, action: #selector(showOptions(gesture:)))
        cell.addGestureRecognizer(longHoldGesture)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        // use the cell as the sender - used later to extract the active run object
        let cell = tableView.cellForRow(at: indexPath)
        
        performSegue(withIdentifier: "showRunDetail", sender: cell)
    }
}

