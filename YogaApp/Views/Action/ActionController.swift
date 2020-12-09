//
//  ActionController.swift
//  YogaApp
//
//  Created by Nill Simon on 02.12.2020.
//  Copyright © 2020 Nill Simon. All rights reserved.
//

import UIKit
import MBCircularProgressBar

class ActionController: UIViewController {
    let settings = UserDefaults.standard
    
    var sec = 0
    var maxSec = 30
    var index = 0
    var timer: Timer = Timer()
    var isAction = true
    
    @IBOutlet weak var titleAsana: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet var progressBar: MBCircularProgressBarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !AdController.ad.interstitial.isReady {
            AdController.ad.getInterstitialAd(delegate: self)
        }
        
        if (settings.object(forKey: "timeForAsana") != nil) {
            maxSec = settings.integer(forKey: "timeForAsana")
        }
        
        if (settings.object(forKey: "shavaIsOn") != nil) {
            if settings.bool(forKey: "shavaIsOn") {
                ModelFireBaseDB.objectDB.actions.append(contentsOf: ModelFireBaseDB.objectDB.cards.filter { $0.id == (Bundle.main.object(forInfoDictionaryKey: "Shava") as! String)})
            }
        } else {
            ModelFireBaseDB.objectDB.actions.append(contentsOf: ModelFireBaseDB.objectDB.cards.filter { $0.id == (Bundle.main.object(forInfoDictionaryKey: "Shava") as! String)})
        }
        
        let breathe = settings.integer(forKey: "breatheIsOn")
        if breathe != -1 {
            ModelFireBaseDB.objectDB.actions.insert(ModelFireBaseDB.objectDB.breathes[breathe], at: 0)
        }
        progressBar.maxValue = CGFloat(maxSec)
        progressBar.value = CGFloat(maxSec)
        sec = maxSec
        
        changeCard()
    }
    
    @IBAction func playToPause(_ sender: Any) {
        if timer.isValid {
            timer.invalidate()
            DispatchQueue.main.async {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.play, target: self, action: #selector(self.playToPause(_:)))
            }
        } else {
            startTimer()
            DispatchQueue.main.async {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.pause, target: self, action: #selector(self.playToPause(_:)))
            }
        }
    }
    
    @IBAction func exit(_ sender: Any) {
        if isAction {
            var wasTimerValid = false
            if timer.isValid {
                timer.invalidate()
                wasTimerValid = true
            }
            
            let alert = UIAlertController(title: "Завершение", message: "Вы уверены, что хотите завершить тренировку? Статистика не будет сохранена!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Отменить", style: .default, handler: { (action) in
                if wasTimerValid {
                    self.startTimer()
                }
            }))
            alert.addAction(UIAlertAction(title: "Завершить!", style: .cancel, handler: { (action) in
                if AdController.ad.interstitial.isReady {
                    AdController.ad.interstitial.present(fromRootViewController: self)
                } else {
                    self.stopAction()
                }
            }))
            present(alert, animated: true, completion: nil)
            
        } else {
            if AdController.ad.interstitial.isReady {
                AdController.ad.interstitial.present(fromRootViewController: self)
            } else {
                stopAction()
            }
        }
    }
    
    func stopAction() {
        ModelFireBaseDB.objectDB.actions = []
        NotificationCenter.default.post(name: NSNotification.Name("actionsRefresh"), object: self)

        timer.invalidate()

        dismiss(animated: true, completion: nil)
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
            
            if self.sec >= 0 {
                UIView.animate(withDuration: 1.0) {
                    self.progressBar.value = CGFloat(self.sec)
                }
            }
            
            self.sec -= 1
            if (self.sec == -5) {
                self.sec = self.maxSec
                
                if self.index == ModelFireBaseDB.objectDB.actions.count {
                    timer.invalidate()
                    ModelFireBaseDB.objectDB.actions = []
                    
                    self.navigationItem.rightBarButtonItem = nil
                    self.titleAsana.text = "Завершено"
                    self.image.image = nil
                    self.progressBar.value = CGFloat(self.maxSec)
                    
                    self.performSegue(withIdentifier: "showCongrats", sender: self)
                    
                    self.isAction = false
                    
                } else {
                    self.changeCard()
                }
            }
        }
    }
    
    func changeCard() {
        
        titleAsana.text = ModelFireBaseDB.objectDB.actions[index].title
        
        image.getImage(url: ModelFireBaseDB.objectDB.actions[index].thumbPath![0])
        
        index += 1
    }
}

extension ActionController : GADInterstitialDelegate {
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        AdController.ad.getInterstitialAd(delegate: self)

        stopAction()
    }
}
