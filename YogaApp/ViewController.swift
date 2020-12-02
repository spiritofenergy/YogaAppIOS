//
//  ViewController.swift
//  YogaApp
//
//  Created by Nill Simon on 16.11.2020.
//  Copyright © 2020 Nill Simon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mainList: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ModelFireBaseDB.objectDB.actions = []
        
        self.navigationItem.rightBarButtonItem = nil
        
        mainList.dataSource = self
        mainList.delegate = self
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("reloadDB"), object: nil, queue: nil) { (notification) in
            self.mainList.reloadData()
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("actionsRefresh"), object: nil, queue: nil) { (note) in
            if ModelFireBaseDB.objectDB.actions.count > 0 {
                DispatchQueue.main.async {
                    let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.play, target: self, action: #selector(self.startAction(_:)))
                    
                    self.navigationItem.rightBarButtonItem = button
                }
            } else {
                self.navigationItem.rightBarButtonItem = nil
            }
        }
    }
    
    @IBAction func startAction(_ sender: Any) {
        
        let nc = storyboard?.instantiateViewController(withIdentifier: "startAction") as! UINavigationController
        nc.modalPresentationStyle = .fullScreen
        
        present(nc, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCard" {
            let selectedCard = ModelFireBaseDB.objectDB.cards[mainList.indexPathForSelectedRow!.row]
            
            (segue.destination as! AsanaController).card = selectedCard
        }
        if segue.identifier == "showCardSlider" {
            let selectedCard = ModelFireBaseDB.objectDB.cards[(sender as! Int)]
            
            (segue.destination as! AsanaController).card = selectedCard
        }
    }
}

extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showCard", sender: self)
    }
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ModelFireBaseDB.objectDB.cards.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainList.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as! CardViewController
        
        let currentCard = ModelFireBaseDB.objectDB.cards[indexPath.row]
        cell.initCell(currentCard: currentCard)
        
        cell.delegateSlider = self
        cell.row = indexPath.row
        
        return cell
    }
}

extension ViewController : ImageSliderDelegate {
    func callSegueFromCell(myData dataobject: AnyObject) {
        performSegue(withIdentifier: "showCardSlider", sender: dataobject)
    }
}
