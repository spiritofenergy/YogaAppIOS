//
//  CardView.swift
//  YogaApp
//
//  Created by Nill Simon on 30.12.2020.
//  Copyright © 2020 Nill Simon. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    @IBOutlet var content: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var sliderView: UICollectionView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var commenLbl: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var opensCardView: UICollectionView!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
