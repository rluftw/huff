//
//  Underline.swift
//  huff
//
//  Created by Xing Hui Lu on 12/7/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit

/*
 color palette
 =============
 red - 204, 0, 0
 yellow - 255, 193, 0
 green - 0, 153, 0
 blue - 0,102,204
 */


@IBDesignable
class UnderlinerTextField: UITextField {

    @IBInspectable var underlineColor: UIColor = UIColor(red: 1, green: 193/255.0, blue: 0, alpha: 1)
    @IBInspectable var placeholderColor: UIColor = UIColor(white: 1, alpha: 0.5)

    
    override func draw(_ rect: CGRect) {        
        // set the underline
        let bottomBorder = CALayer()
        bottomBorder.borderWidth = 2.0
        bottomBorder.frame = CGRect(x: 0, y: bounds.size.height-2.0, width: bounds.size.width, height: 2.0)
        bottomBorder.borderColor = underlineColor.cgColor
        self.layer.addSublayer(bottomBorder)
        
        // change the color of the placeholder text color
        attributedPlaceholder = NSMutableAttributedString(string: placeholder ?? "", attributes: [NSForegroundColorAttributeName: placeholderColor])
    }
    
    // MARK: - overriding the default look
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 10)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 10)
    }
}
