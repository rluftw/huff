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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard Reachability.isConnectedToNetwork() else {
            operationQueue.cancelAllOperations()
            presentAlert(title: "Please check your connection", message: "")
            return
        }
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
        let urlString = photoURLs[indexPath.row]

        // check if the photo is cached (quick operation)
        if let image = imageCache.object(forKey: NSString(string: urlString)) {
            cell.photo = image
        }else {
            print("image cache not found - \(urlString)")

            operationQueue.addOperation({
                // load the large version of the image (slow operation)
                let request = URLRequest(url: URL(string: urlString + ":large")!)
                _ = NetworkOperation.sharedInstance().request(request, completionHandler: { (data, error) in
                    guard error == nil, let data = data else {
                        return
                    }
                    if let image = UIImage(data: data) {
                        self.imageCache.setObject(image, forKey: NSString(string: urlString))
                        // checks to see if the visible cell is still there, if not do not assign the image
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
        let cell = cell as? TweetPhotoCollectionViewCell
        cell?.photo = nil
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
