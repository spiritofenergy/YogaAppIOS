//
//  OpenImageInCard.swift
//  YogaApp
//
//  Created by Nill Simon on 04.12.2020.
//  Copyright © 2020 Nill Simon. All rights reserved.
//

import UIKit

class OpenImageInCard: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    
    func initCell(path: String.SubSequence) {
        
        image.getImage(url: path)
        
    }
    
}
