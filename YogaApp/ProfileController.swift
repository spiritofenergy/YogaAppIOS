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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = Auth.auth().currentUser
        if let user = user {
            nameUser.text = user.displayName
            contactUser.text = user.email ?? user.phoneNumber
            imageProfile.load(url: user.photoURL)
            imageProfile.layer.cornerRadius = imageProfile.frame.height / 2
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
