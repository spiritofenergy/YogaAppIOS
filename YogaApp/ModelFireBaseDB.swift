//
//  ModelFireBaseDB.swift
//  YogaApp
//
//  Created by Nill Simon on 23.11.2020.
//  Copyright © 2020 Nill Simon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class Card {
    var title: String?
    var shortDescription: String?
    var description: String?
    var thumbPath: [UIImage?]?
    
    var likes: Int = 0
    var comments: Int = 0
}

class ModelFireBaseDB: NSObject {
    static let objectDB: ModelFireBaseDB = ModelFireBaseDB()
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    
    var cards: [Card] = []
    
    func getCards() {
        cards = []
        
        db.collection("asunaRU").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let newCard: Card = Card()
                    
                    newCard.title = (document["title"] as! String)
                    newCard.shortDescription = (document["shortDescription"] as! String)
                    newCard.description = (document["description"] as! String)
                    newCard.likes = (document["likes"] as! Int)
                    newCard.comments = (document["comments"] as! Int)
//                    let photos = (document["thumbPath"] as! String).split(separator: " ")
                    
//                    var images: [UIImage] = []
//
//                    for item in photos {
//                        let starsRef = self.storage.child("thumbnails/\(item).jpeg")
//
//                        starsRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
//                            if let error = error {
//                                print(error.localizedDescription)
//                            } else {
//                                let image = UIImage(data: data!)
//                                images.append(image!)
//                            }
//                        }
//                    }
                    
//                    newCard.thumbPath = images
                    
                    self.cards.append(newCard)
                }
                
                NotificationCenter.default.post(name: NSNotification.Name("reloadDB"), object: self)
            }
        }
    }
    
}
