//
//  AuthController.swift
//  YogaApp
//
//  Created by Nill Simon on 23.11.2020.
//  Copyright © 2020 Nill Simon. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class AuthController: UIViewController, GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if error != nil {
            return
        }

        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                let authError = error as NSError
                if (authError.code == AuthErrorCode.secondFactorRequired.rawValue) {
                    // The user is a multi-factor user. Second factor challenge is required.
                    let resolver = authError.userInfo[AuthErrorUserInfoMultiFactorResolverKey] as! MultiFactorResolver
                    var displayNameString = ""
                    for tmpFactorInfo in (resolver.hints) {
                        displayNameString += tmpFactorInfo.displayName ?? ""
                        displayNameString += " "
                    }
                } else {
                    print(error.localizedDescription)
                    return
                }
                return
            }
            let sb: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = sb.instantiateViewController(withIdentifier: "MainInputInAppID")
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated: true, completion: nil)
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        // Если аутентификация произведена, то показываем главное View
        if Auth.auth().currentUser != nil {
            ModelFireBaseDB.objectDB.getCards()
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateUI()
    }
    
    @IBAction func signInGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }

    @IBAction func signInInst(_ sender: Any) {
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
            
            self.view.backgroundColor = Theme.current.backgroundColor
        }
    }
}
