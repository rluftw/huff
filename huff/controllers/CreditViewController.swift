//
//  CreditViewController.swift
//  huff
//
//  Created by Xing Hui Lu on 12/28/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit

class CreditViewController: TextViewController {

    // MARK: - properties
    var creditDict = [String: Any]()
    
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
        let attributes = [
            NSAttributedStringKey.font: UIFont(name: "RobotoMono-Bold", size:12)!,
            NSAttributedStringKey.foregroundColor: UIColor.white,
        ]
        var text = NSMutableAttributedString(string: "THE FOLLOWING SETS FORTH ATTRIBUTION NOTICES FOR THIRD PARTY SOFTWARE/ASSETS THAT MAY BE CONTAINED IN PORTIONS OF THE HUFF PRODUCT\n\n", attributes: attributes)
        
        addIconAttributes(text: &text, attributes: attributes)
        
        textView.attributedText = text
    }
    
    func addIconAttributes(text: inout NSMutableAttributedString, attributes: [NSAttributedStringKey: Any])  {
        text.append(NSAttributedString(string: "ICON ASSETS", attributes: attributes))
        for (key, value) in creditDict {
            let iconText = NSMutableAttributedString(string: "\n\(key) made by \(value) from www.flaticon.com", attributes: attributes)
            text.append(iconText)
        }
    }
}

extension NSMutableAttributedString {
    
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSAttributedStringKey.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}
