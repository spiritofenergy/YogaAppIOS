//
//  ProfileController.swift
//  YogaApp
//
//  Created by Nill Simon on 24.11.2020.
//  Copyright © 2020 Nill Simon. All rights reserved.
//

import UIKit
import Firebase

class ProfileController: UIViewController {
    
    let settings = UserDefaults.standard
    
    
    @IBOutlet weak var profileCard: VProfileCard!
    //    @IBOutlet weak var nameUser: UILabel!
//    @IBOutlet weak var imageProfile: UIImageView!
//    @IBOutlet weak var contactUser: UILabel!
//    @IBOutlet weak var statusUser: UILabel!
    @IBOutlet weak var settingTime: UISegmentedControl!
    @IBOutlet weak var musicToggle: UISwitch!
    @IBOutlet weak var breatheToggle: UISwitch!
    @IBOutlet weak var shavaToggle: UISwitch!
    @IBOutlet weak var musicChooseBlock: UISegmentedControl!
    @IBOutlet weak var breatheChooseBlock: UISegmentedControl!
    @IBOutlet weak var titleSettings: UILabel!
    @IBOutlet weak var subTitleSegment1: UILabel!
    @IBOutlet weak var subTitleSegment2: UILabel!
    @IBOutlet weak var titleTime: UILabel!
    @IBOutlet weak var titleMusic: UILabel!
    @IBOutlet weak var titleBreathe: UILabel!
    @IBOutlet weak var titleShava: UILabel!
    @IBOutlet weak var mainColors: UILabel!
    @IBOutlet weak var themeTitle: UILabel!
    @IBOutlet weak var themeToggle: UISwitch!
    @IBOutlet weak var quit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
        shavaToggle.isOn = true
        
        if settings.object(forKey: "shavaIsOn") != nil {
            shavaToggle.isOn = settings.bool(forKey: "shavaIsOn")
        }
        
        switch settings.integer(forKey: "timeForAsana") {
            case 30:
                settingTime.selectedSegmentIndex = 0
            case 60:
                settingTime.selectedSegmentIndex = 1
            case 90:
                settingTime.selectedSegmentIndex = 2
            default:
                settingTime.selectedSegmentIndex = 0
        }
        
        if settings.integer(forKey: "breatheIsOn") != -1 {
            breatheChooseBlock.selectedSegmentIndex = settings.integer(forKey: "breatheIsOn")
        } else {
            breatheToggle.setOn(false, animated: true)
            breatheChooseBlock.isEnabled = false
            breatheChooseBlock.selectedSegmentIndex = 0
        }
        
        if settings.object(forKey: "lightTheme") != nil {
            themeToggle.isOn = !settings.bool(forKey: "lightTheme")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateUI()
        
        if Auth.auth().currentUser == nil {
            quit.isHidden = true
        }
        
        profileCard.delegate = self
    }
    
    @IBAction func signOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
            ModelFireBaseDB.objectDB.getCards()
            
            profileCard.commonInit()
            
            tabBarController?.selectedIndex = 0
            let sb: UIStoryboard = UIStoryboard(name: "AuthView", bundle: nil)
            let nextViewController = sb.instantiateViewController(withIdentifier: "authID")
            
            self.present(nextViewController, animated: true, completion: nil)
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func changeTime(_ sender: Any) {
        switch settingTime.selectedSegmentIndex
        {
            case 0:
                settings.set(30, forKey: "timeForAsana")
            case 1:
                settings.set(60, forKey: "timeForAsana")
            case 2:
                settings.set(90, forKey: "timeForAsana")
            default:
                settings.set(30, forKey: "timeForAsana")
        }
    }
    
    @IBAction func musicToggleChange(_ sender: Any) {
        if musicToggle.isOn {
            musicChooseBlock.isEnabled = true
        } else {
            musicChooseBlock.isEnabled = false
        }
    }
    
    @IBAction func breatheToggleChange(_ sender: Any) {
        if breatheToggle.isOn {
            breatheChooseBlock.isEnabled = true
            self.settings.set(self.breatheChooseBlock.selectedSegmentIndex, forKey: "breatheIsOn")
        } else {
            let alert = UIAlertController(title: "Отключение", message: "Вы уверены, что хотите отключить дыхание? Вы потеряете 1 уровень!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Отменить", style: .default, handler: { (action) in
                self.settings.set(self.breatheChooseBlock.selectedSegmentIndex, forKey: "breatheIsOn")
                self.breatheToggle.setOn(true, animated: true)
                alert.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Подтверждаю!", style: .cancel, handler: { (action) in
                self.settings.set(-1, forKey: "breatheIsOn")
                self.breatheChooseBlock.isEnabled = false
                alert.dismiss(animated: true, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func shavaToggleChange(_ sender: Any) {
        if shavaToggle.isOn {
            settings.set(true, forKey: "shavaIsOn")
        } else {
            let alert = UIAlertController(title: "Отключение", message: "Вы уверены, что хотите отключить раслабляющую асану? Вы потеряете 1 уровень!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Отменить", style: .default, handler: { (action) in
                self.shavaToggle.setOn(true, animated: true)
                self.settings.set(true, forKey: "shavaIsOn")
                alert.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Подтверждаю!", style: .cancel, handler: { (action) in
                self.settings.set(false, forKey: "shavaIsOn")
                alert.dismiss(animated: true, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func musicChange(_ sender: Any) {
        
    }
    
    @IBAction func breatheChange(_ sender: Any) {
        self.settings.set(self.breatheChooseBlock.selectedSegmentIndex, forKey: "breatheIsOn")
    }
    
    @IBAction func toggleTheme(_ sender: UISwitch) {
        if sender.isOn {
            Theme.current = DarkTheme()
            settings.set(false, forKey: "lightTheme")
        } else {
            settings.set(true, forKey: "lightTheme")
            Theme.current = LightTheme()
        }
        NotificationCenter.default.post(name: NSNotification.Name("changeTheme"), object: self)
        updateUI()
    }
    
    @IBAction func brownSet(_ sender: Any) {
    }
    
    @IBAction func blueSet(_ sender: Any) {
    }
    
    @IBAction func redSet(_ sender: Any) {
    }
    
    @IBAction func yellowSet(_ sender: Any) {
    }
    
    @IBAction func greenSet(_ sender: Any) {
    }
    
    func updateUI() {
        DispatchQueue.main.async {            
            self.navigationController?.navigationBar.barTintColor = Theme.current.toolbarColor
            self.tabBarController?.tabBar.barTintColor = Theme.current.toolbarColor
            
            self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Theme.current.textColor]
            self.tabBarController?.tabBar.tintColor = Colors.current.buttonColor
            self.tabBarController?.tabBar.unselectedItemTintColor = UIColor(named: "UnselectedTitleColor")
            
            self.navigationController?.navigationBar.barStyle = Theme.current.barStyle
            
            self.view.backgroundColor = Theme.current.backgroundColor
            
            self.profileCard.updateUI()
            
            self.titleTime.textColor = Theme.current.textColor
            self.titleMusic.textColor = Theme.current.textColor
            self.titleShava.textColor = Theme.current.textColor
            self.titleBreathe.textColor = Theme.current.textColor
            self.titleSettings.textColor = Theme.current.textColor
            self.themeTitle.textColor = Theme.current.textColor
            self.subTitleSegment1.textColor = Theme.current.textColor
            self.subTitleSegment2.textColor = Theme.current.textColor
            self.mainColors.textColor = Theme.current.textColor
            
            let attr =  [NSAttributedString.Key.foregroundColor: Theme.current.textColor]
            let attrSelected =  [NSAttributedString.Key.foregroundColor: UIColor.black]
            
            self.musicChooseBlock.setTitleTextAttributes(attr, for: .normal)
            self.musicChooseBlock.setTitleTextAttributes(attrSelected, for: .selected)
            
            self.breatheChooseBlock.setTitleTextAttributes(attr, for: .normal)
            self.breatheChooseBlock.setTitleTextAttributes(attrSelected, for: .selected)
            
            self.settingTime.setTitleTextAttributes(attr, for: .normal)
            self.settingTime.setTitleTextAttributes(attrSelected, for: .selected)
        }
    }

}

extension ProfileController : ViewClickBtnDelegate {
    func onClick() {
        
        let actionStoryboard = UIStoryboard(name: "AuthView", bundle: nil)
        let nc = actionStoryboard.instantiateViewController(withIdentifier: "authID") as! UINavigationController
        
        present(nc, animated: true, completion: nil)
        
    }
}
