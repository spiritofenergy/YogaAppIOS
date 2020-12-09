//
//  AdViewCell.swift
//  YogaApp
//
//  Created by Nill Simon on 07.12.2020.
//  Copyright © 2020 Nill Simon. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AdViewCell: UITableViewCell {
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initCell(nativeAd: GADUnifiedNativeAd?) {
        let templateView: GADTMediumTemplateView = GADTMediumTemplateView()
        
        addSubview(templateView)
        
        templateView.nativeAd = nativeAd
        templateView.addHorizontalConstraintsToSuperviewWidth()
        templateView.addVerticalCenterConstraintToSuperview()
        
        updateConstraints()
    }

}
