//
//  ImageCollectionViewCell.swift
//  MultiImagePicker
//
//  Created by CongTruong on 8/30/17.
//  Copyright © 2017 congtruong. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topImageViewConstraint: NSLayoutConstraint!
    
    var durationAnima  = 0.1
    var isSelectedCell = false
    
    func selectCell() -> Bool {
        isSelectedCell = true
        
        topImageViewConstraint.constant = 10
        UIView.animate(withDuration: durationAnima, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
        
        return isSelectedCell
    }
    
    func deselectCell() -> Bool {
        isSelectedCell = false
        
        topImageViewConstraint.constant = 0
        UIView.animate(withDuration: durationAnima, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
        
        return isSelectedCell
    }
}
