//
//  CongratulationController.swift
//  YogaApp
//
//  Created by Nill Simon on 03.12.2020.
//  Copyright © 2020 Nill Simon. All rights reserved.
//

import UIKit

class CongratulationController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func exit(_ sender: Any) {
        ModelFireBaseDB.objectDB.actions = []
        NotificationCenter.default.post(name: NSNotification.Name("actionsRefresh"), object: self)

        dismiss(animated: true, completion: nil)
    }

}
