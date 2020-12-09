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
    
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var contactUser: UILabel!
    @IBOutlet weak var statusUser: UILabel!
    @IBOutlet weak var settingTime: UISegmentedControl!
    @IBOutlet weak var musicToggle: UISwitch!
    @IBOutlet weak var breatheToggle: UISwitch!
    @IBOutlet weak var shavaToggle: UISwitch!
    @IBOutlet weak var musicChooseBlock: UISegmentedControl!
    @IBOutlet weak var breatheChooseBlock: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = Auth.auth().currentUser
        if let user = user {
            nameUser.text = user.displayName
            contactUser.text = user.email ?? user.phoneNumber
            imageProfile.load(url: user.photoURL)
            imageProfile.layer.cornerRadius = imageProfile.frame.height / 2
        }
        
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
        
    }
    
    @IBAction func signOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
            let sb: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = sb.instantiateViewController(withIdentifier: "authID")
            nextViewController.modalPresentationStyle = .fullScreen
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
