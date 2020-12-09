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
    /*
    
    MARK: FIELDS
    
    */
    var delegateSlider: ImageSliderDelegate!
    var row: Int!
    
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    
    var id: String?
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var shortDescriptio: UILabel!
    @IBOutlet weak var imageMain: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var countComments: UILabel!
    @IBOutlet weak var imageSlider: UICollectionView!
    @IBOutlet var addToAction: UIButton!
    @IBOutlet weak var opensImages: UICollectionView!
    
    var card: Card = Card()
    
    /*
     
     MARK: OVERRIDES
     
     */
    override func awakeFromNib() {
        super.awakeFromNib()
        selectedBackgroundView?.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /*
       
    MARK: ACTIONS
       
    */
    @IBAction func liked(_ sender: Any) {
        if likeButton.isSelected {
            ModelFireBaseDB.objectDB.cards[row].likes -= 1
            ModelFireBaseDB.objectDB.cards[row].isCheck = false
            
            likeButton.isSelected = false
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.setTitle("\(card.likes)", for: .normal)
            
            db.collection("likes").document(card.id!).updateData([id : false])
            db.collection("asunaRU").document(card.id!).updateData(["likes" : card.likes])
        } else {
            ModelFireBaseDB.objectDB.cards[row].likes += 1
            ModelFireBaseDB.objectDB.cards[row].isCheck = true
            
            likeButton.isSelected = true
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
            likeButton.setTitle(String(card.likes), for: .selected)
            
            db.collection("likes").document(card.id!).getDocument { (result, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if !result!.exists {
                        self.db.collection("likes").document(self.card.id!).setData([self.id! : true])
                    } else {
                        self.db.collection("likes").document(self.card.id!).updateData([self.id! : true])
                    }
                }
            }
            db.collection("asunaRU").document(card.id!).updateData(["likes" : card.likes])
        }
    }
    
    @IBAction func addAction(_ sender: Any) {
        if (ModelFireBaseDB.objectDB.actions.contains { $0.id == card.id }) {
            if card.opens != nil {
                for id in card.opens! {
                    if let cardOpen = ModelFireBaseDB.objectDB.opensCards[String(id)] {
                        ModelFireBaseDB.objectDB.actions.removeAll { $0.id == cardOpen.id }
                    }
                }
            }
            ModelFireBaseDB.objectDB.actions.removeAll { $0.id == card.id }
        } else {
            if card.opens != nil {
                for id in card.opens! {
                    if let cardOpen = ModelFireBaseDB.objectDB.opensCards[String(id)] {
                        ModelFireBaseDB.objectDB.actions.append(cardOpen)
                    }
                }
            }
            ModelFireBaseDB.objectDB.actions.append(card)
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("actionsRefresh"), object: self)
        
    }
    
    
    /*
    
    MARK: MY FUNCTIONS
    
    */
    func initCell(currentCard: Card) {
        card = currentCard
        
        if Auth.auth().currentUser != nil {
            id = Auth.auth().currentUser!.uid
        }
        
        updateUI()
        
        imageMain.image = nil
        title.text = card.title
        shortDescriptio.text = card.shortDescription
        
        countComments.text = String(card.comments)
        
        likeButton.setTitle("\(card.likes)", for: .normal)
        likeButton.sizeToFit()
        
        if card.isCheck {
            self.likeButton.isSelected = true
            self.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        } else {
            self.likeButton.isSelected = false
            self.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        imageMain.getImage(url: card.thumbPath![0])
        
        imageSlider.dataSource = self
        imageSlider.delegate = self
        
        opensImages.dataSource = self
        
        imageSlider.reloadData()
        opensImages.reloadData()
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

/*

MARK: EXTENSIONS

*/
extension CardViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return card.thumbPath!.count
        }
        if collectionView.tag == 2 {
            return card.opens?.count ?? 0
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            let cell = imageSlider.dequeueReusableCell(withReuseIdentifier: "itemOfImagesSlider", for: indexPath) as! ImageOfSlider
            
            cell.initCell(path: card.thumbPath![indexPath.row])
        
            return cell
        }
        
        if collectionView.tag == 2 {
            let cell = opensImages.dequeueReusableCell(withReuseIdentifier: "cellOpens", for: indexPath) as! OpenImageInCard
            
            let cardOpen = ModelFireBaseDB.objectDB.opensCards[String(card.opens![indexPath.row])]
            
            cell.initCell(path: cardOpen!.thumbPath![0])
        
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension CardViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegateSlider.callSegueFromCell(myData: row as AnyObject)
    }
}
