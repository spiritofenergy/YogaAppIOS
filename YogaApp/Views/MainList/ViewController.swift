//
//  ViewController.swift
//  YogaApp
//
//  Created by Nill Simon on 16.11.2020.
//  Copyright © 2020 Nill Simon. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

class ViewController: UIViewController {
    
    var adLoader: GADAdLoader!
    var countAd = 0
    var isStart = true
    
    @IBOutlet weak var mainList: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
        ModelFireBaseDB.objectDB.actions = []
        
        navigationItem.rightBarButtonItem = nil
        
        mainList.dataSource = self
        mainList.delegate = self
        
        if Auth.auth().currentUser == nil {
            let actionStoryboard = UIStoryboard(name: "AuthView", bundle: nil)
            let nc = actionStoryboard.instantiateViewController(withIdentifier: "authID") as! UINavigationController
            
            present(nc, animated: true, completion: nil)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("reloadDB"), object: nil, queue: nil) { (notification) in
            print("reload")
            self.mainList.reloadData()
            
            self.countAd = Int(floor(Double(ModelFireBaseDB.objectDB.cards.count) / 3.0))
            
            if self.countAd > 0 &&  self.countAd <= 5 {
                AdController.ad.getNativeAds(count: self.countAd, view: self, delegate: self)
            } else {
                AdController.ad.getNativeAds(count: 5, view: self, delegate: self)
                self.countAd -= 5
            }
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("actionsRefresh"), object: nil, queue: nil) { (note) in
            if ModelFireBaseDB.objectDB.actions.count > 0 {
                DispatchQueue.main.async {
                    let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.play, target: self, action: #selector(self.startAction(_:)))
                    button.tintColor = Colors.current.buttonColor
                    self.navigationItem.rightBarButtonItem = button
                }
            } else {
                self.navigationItem.rightBarButtonItem = nil
            }
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("readyInterAd"), object: nil, queue: nil) { (note) in
            if self.isStart {
                if AdController.ad.interstitial.isReady {
                    AdController.ad.interstitial.present(fromRootViewController: self)
                }
            }
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("changeTheme"), object: nil, queue: nil) { (note) in
            self.mainList.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateUI()
        AdController.ad.getInterstitialAd(delegate: self)
    }
    
    @IBAction func startAction(_ sender: Any) {
        
        if AdController.ad.interstitial.isReady {
            AdController.ad.interstitial.present(fromRootViewController: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCard" {
            let selectedCard = ModelFireBaseDB.objectDB.list[mainList.indexPathForSelectedRow!.row] as! Card
            
            (segue.destination as! AsanaController).card = selectedCard
        }
        if segue.identifier == "showCardSlider" {
            let selectedCard = ModelFireBaseDB.objectDB.list[(sender as! Int)] as! Card
            
            (segue.destination as! AsanaController).card = selectedCard
        }
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            self.navigationController?.navigationBar.barTintColor = Theme.current.toolbarColor
            self.tabBarController?.tabBar.barTintColor = Theme.current.toolbarColor
            
            self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Theme.current.textColor]
            self.tabBarController?.tabBar.tintColor = Colors.current.buttonColor
            self.tabBarController?.tabBar.unselectedItemTintColor = UIColor(named: "UnselectedTitleColor")
            
            self.navigationItem.rightBarButtonItem?.tintColor = Colors.current.buttonColor
            self.navigationItem.leftBarButtonItem?.tintColor = Colors.current.buttonColor
            
            self.navigationController?.navigationBar.barStyle = Theme.current.barStyle
            
            self.mainList.backgroundColor = Theme.current.backgroundColor
        }
    }
}

extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ModelFireBaseDB.objectDB.list[indexPath.row] is Card {
            performSegue(withIdentifier: "showCard", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if ModelFireBaseDB.objectDB.list[indexPath.row] is Ad {
            if (ModelFireBaseDB.objectDB.list[indexPath.row] as! Ad).nativeAd == nil {
                return 0
            } else {
                return 370
            }
        }
            
        return tableView.rowHeight
    }
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ModelFireBaseDB.objectDB.list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ModelFireBaseDB.objectDB.list[indexPath.row] is Ad {
            let currentAd = ModelFireBaseDB.objectDB.list[indexPath.row] as! Ad
            let cell = mainList.dequeueReusableCell(withIdentifier: "adCell", for: indexPath) as! AdViewCell
            
            cell.initCell(nativeAd: currentAd.nativeAd)
            
            if currentAd.nativeAd == nil {
                cell.frame.size.height = 0
            }
            
            return cell
        } else {
            let cell = mainList.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as! CardViewController
            
            let currentCard = ModelFireBaseDB.objectDB.list[indexPath.row] as! Card
            cell.initCell(currentCard: currentCard)
            
            cell.delegateSlider = self
            cell.row = indexPath.row
            
            return cell
        }
    }
}

extension ViewController : ImageSliderDelegate {
    func callSegueFromCell(myData dataobject: AnyObject) {
        performSegue(withIdentifier: "showCardSlider", sender: dataobject)
    }
}

extension ViewController : GADUnifiedNativeAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        (ModelFireBaseDB.objectDB.list.first { ($0 is Ad) && ($0 as! Ad).nativeAd == nil } as! Ad).nativeAd = nativeAd
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("Error \(error.localizedDescription)")
    }
    
    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        if self.countAd > 0 {
            if self.countAd <= 5 {
                AdController.ad.getNativeAds(count: self.countAd, view: self, delegate: self)
                self.countAd = 0
            } else {
                AdController.ad.getNativeAds(count: 5, view: self, delegate: self)
                self.countAd -= 5
            }
        }
    }
}

extension ViewController : GADInterstitialDelegate {
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        NotificationCenter.default.post(name: NSNotification.Name("readyInterAd"), object: self)
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        if !self.isStart {
            let actionStoryboard = UIStoryboard(name: "ActionView", bundle: nil)
            let nc = actionStoryboard.instantiateViewController(withIdentifier: "startAction") as! UINavigationController
            nc.modalPresentationStyle = .fullScreen
            
            present(nc, animated: true, completion: nil)
        } else {
            AdController.ad.getInterstitialAd(delegate: self)
            self.isStart = false
        }
    }
}
