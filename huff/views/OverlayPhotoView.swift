//
//  OverlayPhotoView.swift
//  huff
//
//  Created by Xing Hui Lu on 11/28/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit

class OverlayPhotoView: UIView {
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
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
    
    lazy var photoCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 20
        flowLayout.minimumInteritemSpacing = 10
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear //UIColor(red: 1, green: 193/255.0, blue: 0, alpha: 1.0)
        cv.heightAnchor.constraint(equalToConstant: self.bounds.height*0.6).isActive = true
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    
    // MARK: - helper methods
    func setupView() {
        backgroundColor = .clear
        
        // create the blur effect background
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(blurView)
        blurView.addAnchorsTo(topAnchor: topAnchor, rightAnchor: rightAnchor, bottomAnchor: bottomAnchor, leftAnchor: leftAnchor)
        
        // create the vibrancy effect for the subviews
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        
        vibrancyView.contentView.addSubview(cancelButton)
        blurView.addSubview(vibrancyView)
        vibrancyView.addAnchorsTo(topAnchor: blurView.topAnchor, rightAnchor: blurView.rightAnchor, bottomAnchor: blurView.bottomAnchor, leftAnchor: blurView.leftAnchor)
        cancelButton.addAnchorsTo(topAnchor: vibrancyView.topAnchor, rightAnchor: nil, bottomAnchor: nil, leftAnchor: vibrancyView.leftAnchor, topConstant: 16, rightConstant: 0, bottomConstant: 0, leftConstant: 8)
    
        
        // add the photo collection view
        blurView.addSubview(photoCollectionView)
        photoCollectionView.centerYAnchor.constraint(equalTo: blurView.centerYAnchor).isActive = true
        photoCollectionView.addAnchorsTo(topAnchor: nil, rightAnchor: rightAnchor, bottomAnchor: nil, leftAnchor: leftAnchor)
    }
    
    func cancel() {
        removeFromSuperview()
    }
}

extension OverlayPhotoView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionViewCell
        cell.photoURL = photoURLS![indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoURLS!.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let width = collectionView.bounds.width
        let cellWidth: CGFloat = 280
        
        let leftInset = (width-cellWidth)/2
        
        print("left inset: \(leftInset)")
        
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = 280
        let cellHeight = collectionView.bounds.size.height
        
        return CGSize(width: cellWidth, height: cellHeight-20)
    }
}
