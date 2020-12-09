//
//  FavoriteViewController.swift
//  YogaApp
//
//  Created by Nill Simon on 02.12.2020.
//  Copyright © 2020 Nill Simon. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    @IBOutlet var mainList: UITableView!
    
    override func loadView() {
        super.loadView()
        
        ModelFireBaseDB.objectDB.getFavoriteCard()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ModelFireBaseDB.objectDB.actions = []
        
        mainList.dataSource = self
        mainList.delegate = self
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("reloadDB"), object: nil, queue: nil) { (notification) in
            self.mainList.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCard" {
            let selectedCard = ModelFireBaseDB.objectDB.favorite[mainList.indexPathForSelectedRow!.row]
            
            (segue.destination as! AsanaController).card = selectedCard
        }
        if segue.identifier == "showCardSlider" {
            let selectedCard = ModelFireBaseDB.objectDB.favorite[(sender as! Int)]
            
            (segue.destination as! AsanaController).card = selectedCard
        }
    }
}

extension FavoriteViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showCard", sender: self)
    }
}

extension FavoriteViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ModelFireBaseDB.objectDB.favorite.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainList.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as! CardViewController
        
        let currentCard = ModelFireBaseDB.objectDB.favorite[indexPath.row]
        cell.initCell(currentCard: currentCard)
        
        cell.delegateSlider = self
        cell.row = indexPath.row
        
        return cell
    }
}

extension FavoriteViewController : ImageSliderDelegate {
    func callSegueFromCell(myData dataobject: AnyObject) {
        performSegue(withIdentifier: "showCardSlider", sender: dataobject)
    }
}

