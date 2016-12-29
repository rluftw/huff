//
//  OptionsView.swift
//  huff
//
//  Created by Xing Hui Lu on 12/28/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit

protocol OptionsViewDelegate {
    func search()
}

class OptionsView: UIView {

    lazy var radiusTextField: UnderlinerTextField = {
        let tf = self.createTextFieldWithPlaceholder(title: "Search Radius")
        tf.keyboardType = .numberPad
        return tf
    }()
    
    lazy var searchButton: UIButton = {
        let button = self.createButtonWith(title: "Login", image: nil, selector: #selector(search(_:)))
        button.backgroundColor = UIColor(red: 0, green: 153/255.0, blue: 0, alpha: 1)
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        // create the background blur effect
        let blurEffect = UIBlurEffect(style: .light)
        let visualView = UIVisualEffectView(effect: blurEffect)
        visualView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(visualView)
        visualView.addAnchorsTo(topAnchor: topAnchor, rightAnchor: rightAnchor, bottomAnchor: bottomAnchor, leftAnchor: leftAnchor)
    }
    
    func search(_ radius: Int) {
        
    }
    
    func createTextFieldWithPlaceholder(title: String) -> UnderlinerTextField {
        let tf = UnderlinerTextField()
        tf.placeholder = title
        tf.font = UIFont(name: "RobotoMono-Regular", size: 17)
        tf.textColor = .white
        tf.tintColor = .white
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        
        tf.backgroundColor = UIColor(red: 0, green: 102/255.0, blue: 204/255.0, alpha: 1)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return tf
    }
    
    func createButtonWith(title: String?, image: UIImage?, selector: Selector?) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "RobotoMono-Regular", size: 17)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        if let selector = selector {
            button.addTarget(self, action: selector, for: .touchUpInside)
        }
        return button
    }
}
