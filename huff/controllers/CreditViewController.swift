//
//  CreditViewController.swift
//  huff
//
//  Created by Xing Hui Lu on 12/28/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit

class CreditViewController: UIViewController {

    // MARK: - properties
    var creditDict = [String: Any]()
    
    // MARK: - outlets
    @IBOutlet weak var creditTextView: UITextView!
    
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // hide the tool bar
        presentingViewController?.tabBarController?.tabBar.isHidden = true

        loadCreditFromPlist()
        loadTextView()
    }

    // MARK: - actions
    
    @IBAction func close(_ sender: Any) {
        presentingViewController?.tabBarController?.tabBar.isHidden = false
        dismiss(animated: true, completion: nil)
    }
    
    func loadCreditFromPlist() {
        let pListPath = Bundle.main.path(forResource: "Credits", ofType: "plist")!
        if let pListDict = NSDictionary(contentsOfFile: pListPath) as? [String: Any] {
            self.creditDict = pListDict
        }
    }
    
    func loadTextView() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        var attributes = [
            NSFontAttributeName: UIFont(name: "RobotoMono-Bold", size:24)!,
            NSForegroundColorAttributeName: UIColor.white,
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        let text = NSMutableAttributedString(string: "Credits", attributes: attributes)
        attributes[NSParagraphStyleAttributeName] = nil
        attributes[NSFontAttributeName] = UIFont(name: "RobotoMono-Bold", size:16)!
        let iconSubtitle = "\n\nICONS\n-----"
        text.append(NSAttributedString(string: iconSubtitle, attributes: attributes))
        attributes[NSFontAttributeName] = UIFont(name: "RobotoMono-Bold", size:8)!
        for (key, value) in creditDict {
            text.append(NSAttributedString(string: "\n- \(key) made by \(value) from www.flaticon.com", attributes: attributes))
        }
        let appIconSubtitle = "\n\nAPP ICON\n---------"
        attributes[NSFontAttributeName] = UIFont(name: "RobotoMono-Bold", size:16)!
        text.append(NSAttributedString(string: appIconSubtitle, attributes: attributes))
        let appIconDescription = "\nThe app icon named Fitness App Logo is from a user named Ramotion on www.dribbble.com"
        attributes[NSFontAttributeName] = UIFont(name: "RobotoMono-Bold", size:8)!
        text.append(NSAttributedString(string: appIconDescription, attributes: attributes))

        creditTextView.attributedText = text
    }
}
