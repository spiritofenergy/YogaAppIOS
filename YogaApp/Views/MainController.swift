//
//  MainController.swift
//  YogaApp
//
//  Created by Nill Simon on 14.12.2020.
//  Copyright © 2020 Nill Simon. All rights reserved.
//

import UIKit

class MainController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
    }

}

extension MainController : UITabBarDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        <#code#>
    }
}
