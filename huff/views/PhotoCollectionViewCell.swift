//
//  PhotoCollectionViewCell.swift
//  huff
//
//  Created by Xing Hui Lu on 11/27/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit

protocol PhotoTapDelegate: class {
    func photoTapped()
}

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    weak var delegate: PhotoTapDelegate?
    
    var photoURL: String? {
        didSet {
            guard let photoURL = photoURL else {
                photoView.image = UIImage(named: "hash")
                return
            }
            DispatchQueue.global(qos: DispatchQoS.userInteractive.qosClass).async {
                let request = URLRequest(url: URL(string: photoURL + ":thumb")!)
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
}
