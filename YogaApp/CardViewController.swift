//
//  CardViewController.swift
//  YogaApp
//
//  Created by Nill Simon on 22.11.2020.
//  Copyright © 2020 Nill Simon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class CardViewController: UITableViewCell {
    
    let storage = Storage.storage().reference()
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var shortDescriptio: UILabel!
    @IBOutlet weak var imageMain: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var countComments: UILabel!
    @IBOutlet weak var imageSlider: UICollectionView!
    
    var card: Card = Card()
    
    func initCell(currentCard: Card) {
        card = currentCard
        
        updateUI()
        
        imageMain.image = nil
        title.text = card.title
        shortDescriptio.text = card.shortDescription
        
        countComments.text = String(card.comments)
        
        likeButton.setTitle("\(card.likes)", for: .normal)
        likeButton.sizeToFit()
        
//        self.imageMain.image = card.thumbPath![0]

        
        imageSlider.dataSource = self
        
        imageSlider.reloadData()
    }
    
    @IBAction func liked(_ sender: Any) {
        if likeButton.isSelected {
            likeButton.isSelected = false
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.setTitle("\(card.likes)", for: .normal)
        } else {
            likeButton.isSelected = true
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)

            likeButton.setTitle(String(card.likes + 1), for: .selected)
        }
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
    

    override func awakeFromNib() {
        super.awakeFromNib()
        selectedBackgroundView?.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension CardViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return card.thumbPath!.count
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageSlider.dequeueReusableCell(withReuseIdentifier: "itemOfImagesSlider", for: indexPath) as! ImageOfSlider
        
        for _ in card.thumbPath! {
            // ADD IMAGE
        }
        
        return cell
    }
}

