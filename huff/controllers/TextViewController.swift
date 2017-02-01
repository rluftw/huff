//
//  TextViewController.swift
//  huff
//
//  Created by Xing Hui Lu on 1/22/17.
//  Copyright © 2017 Xing Hui Lu. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {

    // MARK: - outlets
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
            textView.scrollRangeToVisible(NSMakeRange(0, 0))
            
            // this seems like a bug - text is getting cut off
            // the following forces the full rendering
            textView.isScrollEnabled = false
            textView.isScrollEnabled = true
        }
    }

}
