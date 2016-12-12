//
//  TweetPhotosViewController.swift
//  huff
//
//  Created by Xing Hui Lu on 12/10/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit

class TweetPhotosViewController: UIViewController {

    // MARK: - properties
    var photoURLs: [String]!
    let imageCache = NSCache<NSString, UIImage>()
    let operationQueue: OperationQueue = {
       let oq = OperationQueue()
        oq.qualityOfService = .userInteractive
        return oq
    }()
    
    // MARK: - outlets
    @IBOutlet weak var photoCollectionView: UICollectionView! {
        didSet {
            photoCollectionView.delegate = self
            photoCollectionView.dataSource = self
        }
    }
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - actions
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension TweetPhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - collection view datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! TweetPhotoCollectionViewCell
        
        // load the photo
        let urlString = photoURLs[indexPath.row] + ":large"

        // check if the photo is cached
        if let image = imageCache.object(forKey: NSString(string: urlString)) {
            print("image key found - attempting to load from cache")
            cell.photo = image
        }else {
            operationQueue.addOperation({
                let request = URLRequest(url: URL(string: urlString)!)
                _ = NetworkOperation.sharedInstance().request(request, completionHandler: { (data, error) in
                    guard error == nil else {
                        return
                    }
                    if let image = UIImage(data: data!) {
                        self.imageCache.setObject(image, forKey: NSString(string: urlString))
                        
                        DispatchQueue.main.async(execute: {
                            cell.photo = image
                        })
                    }
                })
            })
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // reset the image
        let tweetCell = cell as! TweetPhotoCollectionViewCell
        tweetCell.photoView.image = nil
    }
    
    // MARK: - cell layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let width = collectionView.bounds.width
        let cellWidth = collectionView.bounds.width*0.80
        let leftInset = (width-cellWidth)/2
        
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = collectionView.bounds.width*0.80
        let cellHeight = collectionView.bounds.size.height

        return CGSize(width: cellWidth, height: cellHeight-20)
    }
}