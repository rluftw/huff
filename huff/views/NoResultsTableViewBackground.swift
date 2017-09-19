//
//  NoResultsTableViewBackground.swift
//  huff
//
//  Created by Xing Hui Lu on 12/27/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit

class NoResultsTableViewBackground: UIView {
    var title: String! {
        didSet {
            let attributes: [NSAttributedStringKey: Any] = [
                NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): UIFont(name: "RobotoMono-Bold", size:17)!,
                NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white
            ]
            titleLabel.attributedText = NSAttributedString(string: title, attributes: attributes)
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.widthAnchor.constraint(equalToConstant: self.bounds.width*0.8).isActive = true
        return label
    }()
    
    lazy var photoView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "problem")
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: self.bounds.size.width/3).isActive = true
        iv.heightAnchor.constraint(equalToConstant: self.bounds.size.width/3).isActive = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        addSubview(photoView)
        addSubview(titleLabel)
        
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: photoView.topAnchor, constant: -10).isActive = true
        photoView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        photoView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
