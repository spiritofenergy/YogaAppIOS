//
//  DarkTheme.swift
//  YogaApp
//
//  Created by Nill Simon on 10.12.2020.
//  Copyright © 2020 Nill Simon. All rights reserved.
//

import UIKit

class DarkTheme : ThemeProtocol {
    var barStyle: UIBarStyle = .black
    
    var textColor: UIColor = UIColor.white
    var shadowColor: UIColor =  UIColor.white
    
    var backgroundColor: UIColor = UIColor(named: "BackgroundDarkThemeColor")!
    
    var toolbarColor: UIColor = UIColor(named: "ToolbarDarkThemeColor")!
}
