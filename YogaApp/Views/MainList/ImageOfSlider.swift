//
//  ImageOfSlider.swift
//  YogaApp
//
//  Created by Nill Simon on 25.11.2020.
//  Copyright © 2020 Nill Simon. All rights reserved.
//

import UIKit

class ImageOfSlider: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet var imageOne: UIImageView!
    
    func initCell(path: String.SubSequence) {
        updateUI()
        
        image.getImage(url: path)
    }
    
    func initCellIn(path: String.SubSequence) {
        updateUI()
        
        imageOne.getImage(url: path)
    }
    
    func updateUI() {
        
    }
    
}
