//
//  VProfileCard.swift
//  YogaApp
//
//  Created by Nill Simon on 29.12.2020.
//  Copyright © 2020 Nill Simon. All rights reserved.
//

import UIKit
import Firebase

class VProfileCard: UIView {

    @IBOutlet var content: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var contactLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var imageImg: UIImageView!
    @IBOutlet weak var authBtn: UIButton!
    
    public var delegate: ViewClickBtnDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    public func commonInit() {
        Bundle.main.loadNibNamed("VProfileCard", owner: self, options: nil)
        addSubview(content)
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        updateUI()
        
        if Auth.auth().currentUser == nil {
            authBtn.isHidden = false
        } else {
            let user = Auth.auth().currentUser

            nameLbl.text = user!.displayName
            contactLbl.text = user!.email ?? user!.phoneNumber
            imageImg.load(url: user!.photoURL)
            imageImg.layer.cornerRadius = imageImg.frame.height / 2
            authBtn.isHidden = true
            

        }
        
    }
    
    public func updateUI() {
        content.backgroundColor = Theme.current.backgroundColor
        nameLbl.textColor = Theme.current.textColor
        contactLbl.textColor = Theme.current.textColor
        imageImg.tintColor = Theme.current.textColor
    }
    
    @IBAction func authClick(_ sender: Any) {
        delegate?.onClick()
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
