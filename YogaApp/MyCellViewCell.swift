//
//  MyCellViewCell.swift
//  YogaApp
//
//  Created by Nill Simon on 24.11.2020.
//  Copyright © 2020 Nill Simon. All rights reserved.
//

import UIKit

class MyCellViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI() {
        bgView.clipsToBounds = true
        
        bgView.backgroundColor = UIColor.systemBackground
        bgView.layer.cornerRadius = 5
        bgView.layer.masksToBounds = false
        
        bgView.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        bgView.layer.shadowOffset = CGSize(width: 0, height: 0)
        bgView.layer.shadowOpacity = 0.8
    }

}
