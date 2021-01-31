//
//  ModelFireBaseDB.swift
//  YogaApp
//
//  Created by Nill Simon on 23.11.2020.
//  Copyright © 2020 Nill Simon. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds
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
    var opens: [String.SubSequence]?
}

class Ad {
    var nativeAd: GADUnifiedNativeAd?
}

class UserPromo {
    var promocode: String?
    var usesPromo: Int = 0
    var usedPromo: String?
    var sale: Int = 0
}

class ModelFireBaseDB: NSObject {
    static let objectDB: ModelFireBaseDB = ModelFireBaseDB()
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    var userID: String?
    
    var cards: [Card] = []
    var list: [Any] = []
    var opensCards: [String: Card] = [:]
    var favorite: [Card] = []
    var actions: [Card] = []
    var breathes: [Card] = []
    
    var user: UserPromo = UserPromo()
    
    func getCards() {
        getOpensCard()
        getBreathesCard()
        cards = []
        favorite = []
        
        if Auth.auth().currentUser != nil {
            userID = Auth.auth().currentUser!.uid
        }
        
        db.collection("asunaRU").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for (index, document) in querySnapshot!.documents.enumerated() {
                    let newCard: Card = Card()
                    newCard.id = document.documentID
                    newCard.title = (document["title"] as! String)
                    newCard.shortDescription = (document["shortDescription"] as! String)
                    newCard.description = (document["description"] as! String)
                    newCard.likes = (document["likes"] as! Int)
                    newCard.comments = (document["comments"] as! Int)
                    
                    let photos = (document["thumbPath"] as! String).split(separator: " ")
                    newCard.thumbPath = photos
                    
                    let opens = (document["openAsans"] as? String)?.split(separator: " ")
                    newCard.opens = opens
                    
                    self.cards.append(newCard)
                    self.list.append(newCard)
                    if ((index + 1) % 3 == 0) {
                        let newAd: Ad = Ad()
                        newAd.nativeAd = nil
                        self.list.append(newAd)
                    }
                }
                
                self.db.collection("likes").getDocuments { (documentLike, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        for document in documentLike!.documents {
                            if self.userID != nil {
                                if document[self.userID!] != nil {
                                    for (index, card) in self.cards.enumerated() {
                                        if card.id == document.documentID {
                                            self.cards[index].isCheck = document[self.userID!] as! Bool
                                            if self.cards[index].isCheck {
                                                self.favorite.append(card)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        NotificationCenter.default.post(name: NSNotification.Name("reloadDB"), object: self)
                    }
                }
                
                
            }
        }
    }
    
    func getOpensCard() {
        opensCards = [:]
        
        db.collection("openAsunaRU").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let newCard: Card = Card()
                    newCard.id = document.documentID
                    newCard.title = (document["title"] as? String)
                    newCard.description = (document["description"] as! String)
                    
                    let photos = (document["thumbPath"] as! String).split(separator: " ")
                    newCard.thumbPath = photos
                    
                    self.opensCards[newCard.id!] = newCard
                }
                
            }
        }
        
    }
    
    func getBreathesCard() {
        breathes = []
        
        db.collection("dyh").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let newCard: Card = Card()
                    newCard.id = document.documentID
                    newCard.title = (document["title"] as! String)
                    
                    let photos = (document["thumbPath"] as! String).split(separator: " ")
                    newCard.thumbPath = photos
                    
                    self.breathes.append(newCard)
                }
                
            }
        }
        
    }
    
    func getFavoriteCard() {
        favorite = []
        
        for card in cards {
            if card.isCheck {
                favorite.append(card)
            }
        }
    }
    
    func getUserPromo() {
        
        if Auth.auth().currentUser != nil {
            userID = Auth.auth().currentUser!.uid
        }
        
        if self.userID != nil {
            db.collection("users")
                .whereField("id", isEqualTo: userID!)
                .getDocuments { (query, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        for document in query!.documents {
                            
                            let id = document.get("promocode_id") as? String
                            let sale = document.get("sale") as? Int
                            self.user.usedPromo = document.get("uses_promocode_id") as? String
                            
                            if let s = sale {
                                self.user.sale = s
                            }
                            

                            if (id != nil) {
                                self.db.collection("promocodes")
                                    .document(id!)
                                    .getDocument { (queryPromo, error) in
                                        if let error = error {
                                            print("Error getting documents: \(error)")
                                        } else {
                                            self.user.promocode = queryPromo?["promocode"] as? String
                                            let uses = queryPromo?.get("used_times") as? Int
                                            if let u = uses {
                                                self.user.usesPromo = u
                                            }
                                        }
                                    }
                            } else {
                                self.createPromo()
                            }
                        }
                    }
            }
        }
    }
    
    func setPromo(promo: String) {
        if Auth.auth().currentUser != nil {
            userID = Auth.auth().currentUser!.uid
        }
        var promoId = ""
        
        db.collection("promocodes")
            .whereField("promocode", isEqualTo: promo)
            .getDocuments { (query, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    if !query!.isEmpty {
                        for doc in query!.documents {
                            promoId = doc.documentID
                            var times = 0
                            if let u = doc["used_times"] as? Int {
                                times = u
                            }
                            
                            self.db.collection("promocodes")
                                .document(promoId)
                            .updateData(["used_times" : times + 1])
                        }
                        
                        self.db.collection("users")
                            .whereField("id", isEqualTo: self.userID!)
                            .getDocuments { (query, error) in
                                if let error = error {
                                    print("Error getting documents: \(error)")
                                } else {
                                    if !query!.isEmpty {
                                        for doc in query!.documents {
                                            self.db.collection("users")
                                                .document(doc.documentID)
                                                .updateData(["uses_promocode_id" : promo, "sale": 10]) { (error) in
                                                    if let error = error {
                                                        print("Error getting documents: \(error)")
                                                    } else {
                                                        self.db.collection("users")
                                                            .whereField("promocode_id", isEqualTo: promoId)
                                                            .getDocuments { (query, error) in
                                                                if let error = error {
                                                                    print("Error getting documents: \(error)")
                                                                } else {
                                                                    if !query!.isEmpty {
                                                                        for user in query!.documents {
                                                                            self.db.collection("users")
                                                                                .document(user.documentID)
                                                                                .updateData(["sale" : 50])
                                                                        }
                                                                    }
                                                                }
                                                        }
                                                        
                                                        self.user.sale = 10
                                                        self.user.usedPromo = promo
                                                        
                                                        NotificationCenter.default.post(name: NSNotification.Name("updateUserPromo"), object: self)
                                                    }
                                            }
                                        }
                                    }
                                }
                        }
                    }
                }
        }
        
    }
    
    func createPromo() {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let promo = String((0..<6).map{ _ in letters.randomElement()! })
        
        user.promocode = promo
        
        var ref: DocumentReference? = nil
        ref = db.collection("promocodes")
            .addDocument(data: ["promocode": promo], completion: { (error) in
                if let err = error {
                    print("Error adding document: \(err)")
                } else {
                    
                    self.db.collection("users")
                        .whereField("id", isEqualTo: self.userID!)
                        .getDocuments { (user, error) in
                            if let err = error {
                                print("Error getting documents: \(err)")
                            } else {
                                if !user!.isEmpty {
                                    for u in user!.documents {
                                        self.db.collection("users")
                                            .document(u.documentID)
                                            .updateData(["promocode_id" : ref!.documentID])
                                    }
                                }
                            }
                    }
                    
                }
            })
    }
    
}
