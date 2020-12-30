//
//  ThemeProtocol.swift
//  YogaApp
//
//  Created by Nill Simon on 10.12.2020.
//  Copyright © 2020 Nill Simon. All rights reserved.
//

import UIKit

protocol ThemeProtocol {
    var textColor: UIColor { get }
    var shadowColor: UIColor { get }
    var barStyle: UIBarStyle { get }
    var backgroundColor: UIColor { get }
    var toolbarColor: UIColor { get }
}
