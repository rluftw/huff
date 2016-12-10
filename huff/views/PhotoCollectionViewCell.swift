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
        let ai = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        ai.color = UIColor(red: 1, green: 193/255.0, blue: 0, alpha: 1)
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
            setImage(image: nil)
            activityIndicator.startAnimating()
            guard let photoURL = photoURL else {
                return
            }

            DispatchQueue.global(qos: DispatchQoS.userInteractive.qosClass).async {
                let request = URLRequest(url: URL(string: photoURL + ":large")!) 
                _ = NetworkOperation.sharedInstance().request(request, completionHandler: { (data, error) in
                    DispatchQueue.main.async(execute: {
                        guard let data = data, let image = UIImage(data: data) else {
                            self.setImage(image: nil)
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
        setImage(image: image)
        activityIndicator.stopAnimating()
        setNeedsDisplay()
    }
    
    
    // sets up the image, defaults if the image is nil
    func setImage(image: UIImage?) {
        activityIndicator.stopAnimating()
        guard let image = image else {
            photoView.contentMode = .center
            photoView.image = UIImage(named: "hash")
            return
        }
        
        photoView.contentMode = .scaleAspectFill
        photoView.image = image
    }
}
