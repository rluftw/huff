//
//  OverlayPhotoView.swift
//  huff
//
//  Created by Xing Hui Lu on 11/28/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit

class OverlayPhotoView: UIView {
    
    // MARK: - subviews
    var effectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        //button.backgroundColor = UIColor(red: 204/255.0, green: 0, blue: 0, alpha: 1.0)
        button.tintColor = .white
        button.setImage(UIImage(named: "cancel"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.widthAnchor.constraint(equalToConstant: 60).isActive = true
        button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return button
    }()
    
    // MARK: - properties
    var photoURLS: [String]?
    
    // TODO: we're gonna have a collection view shown after the user taps on the cell
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - helper methods
    func setupView() {
        backgroundColor = .clear
        addSubview(effectView)
        
        effectView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        effectView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        effectView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        effectView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        effectView.addSubview(cancelButton)
        
        cancelButton.topAnchor.constraint(equalTo: effectView.topAnchor, constant: 16).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: effectView.leftAnchor, constant: 8).isActive = true
    }
    
    func cancel() {
        removeFromSuperview()
    }
}
