//
//  MultiPickerViewController.swift
//  MultiImagePicker
//
//  Created by CongTruong on 8/30/17.
//  Copyright © 2017 congtruong. All rights reserved.
//

import UIKit
import Photos

class MultiPickerViewController: UIViewController {
    
    @IBOutlet weak var uploadImageButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var urlImage: [URL?]!   // <-- Array to hold url of image
    var isSelectItem: [Bool]! // <-- Array to hold item is select
    var countPicked = 0
    var photosAsset: PHFetchResult<PHAsset>!
    
    var indexStart: IndexPath?
    var indexEnd:   IndexPath?
    var indexTemp:  IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPhotos()
    }
    
    @IBAction func upload(_ sender: Any) {
        var urlSelected = [URL]()
        
        let count = urlImage.count
        for i in 0 ..< count {
            if isSelectItem[i] && urlImage[i] != nil {
                urlSelected.append(urlImage[i]!)
            }
        }
        
        for i in urlSelected {
            print(i)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var minRange: IndexPath!
    var maxRange: IndexPath!
    
    @IBAction func getStartPoint(_ sender: UILongPressGestureRecognizer) {
        
        let point = sender.location(in: collectionView)
        
        if sender.state == .began {
            indexStart = collectionView.indexPathForItem(at: point)
            indexEnd = indexStart
        }
        else if sender.state == .changed {
            indexTemp = indexEnd
            indexEnd = collectionView.indexPathForItem(at: point)
        }
        else if sender.state == .ended {
            indexEnd = nil
            indexStart = nil
            indexTemp = nil
        }
        
        
        guard let start = indexStart else {
            return
        }
        guard let end = indexEnd else {
            return
        }
        
        // deselect range
        if let temp = indexTemp {
            minRange = min(temp, end)
            maxRange = max(temp, end)
            
            while minRange <= maxRange {
                
                let tempCell = collectionView.cellForItem(at: minRange) as! ImageCollectionViewCell
                
                // if cell selected before -> down count
                if tempCell.isSelectedCell {
                    countPicked -= 1
                }
                // set selected for item
                isSelectItem[minRange.row] = tempCell.deselectCell()
                
                minRange.row += 1
            }
        }
        
        // select range
        minRange = min(start, end)
        maxRange = max(start, end)
        
        while minRange <= maxRange {
            
            let startCell = collectionView.cellForItem(at: minRange) as! ImageCollectionViewCell
            
            // if cell not selected before -> up count
            if startCell.isSelectedCell == false {
                countPicked += 1
            }
            // set selected for item
            isSelectItem[minRange.row] = startCell.selectCell()
            countLabel.text = String(countPicked)
            
            minRange.row += 1
        }
    }
    
}

// extension for load all image from galary
extension MultiPickerViewController {
    
    func fetchPhotos () {
        //imagesGalary = [UIImage]()
        urlImage     = [URL]()
        self.fetchPhotoAtIndexFromEnd(index: 0)
    }
    
    // Repeatedly call the following method while incrementing
    // the index until all the photos are fetched
    func fetchPhotoAtIndexFromEnd(index:Int) {
        
        // Note that if the request is not set to synchronous
        // the requestImageForAsset will return both the image
        // and thumbnail; by setting synchronous to true it
        // will return just the thumbnail
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        
        // Sort the images by creation date
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
        
        self.photosAsset = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
        self.isSelectItem = [Bool].init(repeating: false, count: self.photosAsset.count)
    }
    
}

extension MultiPickerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(self.photosAsset != nil){
            return self.photosAsset.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        
        //Modify the cell
        let asset: PHAsset = self.photosAsset[indexPath.item]
        
        PHImageManager.default().requestImage(for: asset, targetSize: view.frame.size, contentMode: PHImageContentMode.aspectFill, options: requestOptions, resultHandler: { (image, _) in
            if let img = image {
                cell.imageView.image = img
                asset.getURL(completionHandler: { (url) in
                    self.urlImage.append(url)
                })
            }
        })
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
        
        // set select flag for item
        isSelectItem[indexPath.row] = cell.isSelectedCell ? cell.deselectCell() : cell.selectCell()
        
        if cell.isSelectedCell {
            countPicked += 1
        }
        else {
            countPicked -= 1
        }
        countLabel.text = String(countPicked)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizeWidth = self.view.bounds.size.width / 3 - 1
        
        return CGSize(width: sizeWidth, height: sizeWidth)
    }
}
























