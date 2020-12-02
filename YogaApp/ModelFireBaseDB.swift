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
    var id: String?
    var title: String?
    var shortDescription: String?
    var description: String?
    var thumbPath: [String.SubSequence]?
    var isCheck: Bool = false
    var likes: Int = 0
    var comments: Int = 0
}

class ModelFireBaseDB: NSObject {
    static let objectDB: ModelFireBaseDB = ModelFireBaseDB()
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    var userID: String?
    
    var cards: [Card] = []
    
    func getCards() {
        cards = []
        
        if Auth.auth().currentUser != nil {
            userID = Auth.auth().currentUser!.uid
        }
        
        db.collection("asunaRU").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let newCard: Card = Card()
                    newCard.id = document.documentID
                    newCard.title = (document["title"] as! String)
                    newCard.shortDescription = (document["shortDescription"] as! String)
                    newCard.description = (document["description"] as! String)
                    newCard.likes = (document["likes"] as! Int)
                    
                    
                    
                    newCard.comments = (document["comments"] as! Int)
                    let photos = (document["thumbPath"] as! String).split(separator: " ")
                    
                    newCard.thumbPath = photos
                    
                    self.cards.append(newCard)
                }
                
                self.db.collection("likes").getDocuments { (documentLike, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        for (index, document) in documentLike!.documents.enumerated() {
                            if document[self.userID!] != nil {
                                self.cards[index].isCheck = document[self.userID!] as! Bool
                            }
                        }
                        
                        NotificationCenter.default.post(name: NSNotification.Name("reloadDB"), object: self)
                    }
                }
                
                
            }
        }
    }
}
