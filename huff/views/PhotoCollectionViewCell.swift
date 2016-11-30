//
//  PhotoCollectionViewCell.swift
//  huff
//
//  Created by Xing Hui Lu on 11/27/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit


class PhotoCollectionViewCell: UICollectionViewCell {
    var photoView: UIImageView = {
        let pv = UIImageView()
        pv.contentMode = .scaleAspectFill
        return pv
    }()
    
    var activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.startAnimating()
        ai.hidesWhenStopped = true
        return ai
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var photoURL: String? {
        didSet {
            guard let photoURL = photoURL else {
                photoView.image = UIImage(named: "hash")
                return
            }
            DispatchQueue.global(qos: DispatchQoS.userInteractive.qosClass).async {
                let request = URLRequest(url: URL(string: photoURL + ":large")!) // TODO: add the photo size
                _ = NetworkOperation.sharedInstance().request(request, completionHandler: { (data, error) in
                    DispatchQueue.main.async(execute: {
                        guard let data = data else {
                            self.photoView.image = UIImage(named: "hash")
                            return
                        }
                        self.photoView.image = UIImage(data: data)
                        self.activityIndicator.stopAnimating()
                        self.setNeedsDisplay()
                    })
                })
            }
        }
    }
    
    func setupView() {
        addSubview(photoView)
        photoView.addSubview(activityIndicator)
        
        // photoView.addAnchorsTo(topAnchor: topAnchor, rightAnchor: rightAnchor, bottomAnchor: bottomAnchor, leftAnchor: leftAnchor)
    }
}
