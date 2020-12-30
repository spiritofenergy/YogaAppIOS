//
//  AddViewController.swift
//  YogaApp
//
//  Created by Nill Simon on 11.12.2020.
//  Copyright © 2020 Nill Simon. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateUI()
    }
    
    func updateUI() {
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
