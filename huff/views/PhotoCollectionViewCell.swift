//
//  PhotoCollectionViewCell.swift
//  huff
//
//  Created by Xing Hui Lu on 11/27/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit


class PhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - outlets
    var photoView: UIImageView = {
        let pv = UIImageView()
        pv.contentMode = .scaleAspectFill
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.clipsToBounds = true
        return pv
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.startAnimating()
        ai.hidesWhenStopped = true
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - the model
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
                        guard let data = data, let image = UIImage(data: data) else {
                            self.photoView.image = UIImage(named: "hash")
                            return
                        }
                        self.stopLoadingAndUpdateDisplay(image: image)
                    })
                })
            }
        }
    }
    
    // MARK: - helper methods
    
    func setupView() {
        addSubview(photoView)
        photoView.addSubview(activityIndicator)
        
        
        // constraints management
        photoView.addAnchorsTo(topAnchor: topAnchor, rightAnchor: rightAnchor, bottomAnchor: bottomAnchor, leftAnchor: leftAnchor)
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func stopLoadingAndUpdateDisplay(image: UIImage) {
        self.photoView.image = image
        self.activityIndicator.stopAnimating()
        self.setNeedsDisplay()
    }
}
