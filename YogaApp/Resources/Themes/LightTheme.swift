//
//  LightTheme.swift
//  YogaApp
//
//  Created by Nill Simon on 10.12.2020.
//  Copyright © 2020 Nill Simon. All rights reserved.
//

import UIKit

class LightTheme : ThemeProtocol {
    var textColor: UIColor = UIColor.black
    var shadowColor: UIColor =  UIColor.black
    var barStyle: UIBarStyle = .default
    
    var backgroundColor: UIColor = UIColor(named: "BackgroundLightThemeColor")!
    
    var toolbarColor: UIColor = UIColor(named: "ToolbarLightThemeColor")!
}
