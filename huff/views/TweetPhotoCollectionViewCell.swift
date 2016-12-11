//
//  TweetPhotoCollectionCollectionViewCell.swift
//  huff
//
//  Created by Xing Hui Lu on 12/10/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit

class TweetPhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - properties
    var photo: UIImage! {
        didSet {
            photoView.image = photo
        }
    }
    
    // MARK: - outlets
    @IBOutlet weak var photoView: UIImageView!
}
