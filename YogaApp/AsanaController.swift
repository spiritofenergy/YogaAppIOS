//
//  AsanaController.swift
//  YogaApp
//
//  Created by Nill Simon on 24.11.2020.
//  Copyright © 2020 Nill Simon. All rights reserved.
//

import UIKit

class AsanaController: UIViewController {
    
    var card: Card?
    @IBOutlet var titleAsana: UILabel!
    @IBOutlet var descAsana: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleAsana.text = card?.title
        descAsana.text = card?.description
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
