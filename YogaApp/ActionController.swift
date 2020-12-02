//
//  ActionController.swift
//  YogaApp
//
//  Created by Nill Simon on 02.12.2020.
//  Copyright © 2020 Nill Simon. All rights reserved.
//

import UIKit

class ActionController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func exit(_ sender: Any) {
        ModelFireBaseDB.objectDB.actions = []
        NotificationCenter.default.post(name: NSNotification.Name("actionsRefresh"), object: self)
        
        dismiss(animated: true, completion: nil)
    }
}
