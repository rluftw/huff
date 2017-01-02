//
//  UIViewAnchor.swift
//  huff
//
//  Created by Xing Hui Lu on 11/29/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit

extension UIView {
    func addAnchorsTo(topAnchor: NSLayoutYAxisAnchor?, rightAnchor: NSLayoutXAxisAnchor?, bottomAnchor: NSLayoutYAxisAnchor?, leftAnchor: NSLayoutXAxisAnchor?, topConstant: CGFloat=0, rightConstant: CGFloat=0, bottomConstant:CGFloat=0, leftConstant: CGFloat=0) {
        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: topConstant).isActive = true
        }
        
        if let rightAnchor = rightAnchor {
            self.rightAnchor.constraint(equalTo: rightAnchor, constant: rightConstant).isActive = true
        }
        
        if let bottomAnchor = bottomAnchor {
            self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomConstant).isActive = true
        }
        
        if let leftAnchor = leftAnchor {
            self.leftAnchor.constraint(equalTo: leftAnchor, constant: leftConstant).isActive = true
        }
    }
}
