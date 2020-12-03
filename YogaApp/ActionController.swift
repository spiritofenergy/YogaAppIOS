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
    
    @IBOutlet weak var titleAsana: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet var progressBar: MBCircularProgressBarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (settings.object(forKey: "timeForAsana") != nil) {
            maxSec = settings.integer(forKey: "timeForAsana")
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
                    
                } else {
                    self.changeCard()
                }
            }
        }
    }
    
    func changeCard() {
        
        titleAsana.text = ModelFireBaseDB.objectDB.actions[index].title
        
        getImage(url: ModelFireBaseDB.objectDB.actions[index].thumbPath![0]) { (image) in
            if let image = image {
                self.image.image = image
            }
        }
        
        index += 1
    }
}
