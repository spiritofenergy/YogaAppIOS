//
//  CongratulationsViewController.swift
//  YogaApp
//
//  Created by Nill Simon on 11.12.2020.
//  Copyright © 2020 Nill Simon. All rights reserved.
//

import UIKit

class CongratulationsViewController: UIViewController {
    
    @IBOutlet weak var mainText: UILabel!
    @IBOutlet weak var subText: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateUI()
    }
    
    func updateUI() {
        self.view.backgroundColor = Theme.current.backgroundColor
        
        self.mainText.textColor = Theme.current.textColor
        self.subText.textColor = Theme.current.textColor
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
