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
   
    func initCell(url: URL?) {
        updateUI()
        
//        image.load(url: url)
    }
    
    func updateUI() {
        
    }
    
}
