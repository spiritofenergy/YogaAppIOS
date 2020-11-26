//
//  TestController.swift
//  YogaApp
//
//  Created by Nill Simon on 24.11.2020.
//  Copyright © 2020 Nill Simon. All rights reserved.
//

import UIKit

class TestController: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    let content = ["Test", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam bibendum leo ut cursus maximus. Sed lacinia mollis metus, et dictum purus.", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam bibendum leo ut cursus maximus. Sed lacinia mollis metus, et dictum purus. Donec placerat velit vitae placerat facilisis. Morbi cursus, justo quis viverra ultrices, ante orci sodales velit, sit amet pretium tellus urna in arcu. Suspendisse iaculis feugiat neque ut pulvinar. Etiam rutrum erat eget odio pulvinar, quis eleifend dolor venenatis. Nulla sed dictum erat. Proin ullamcorper, elit a rhoncus elementum, urna mauris maximus augue, a mattis felis elit a nulla. Cras purus erat, vestibulum at erat at, tincidunt accumsan dolor. Sed sit amet lectus pellentesque, finibus odio eget, scelerisque mi. Phasellus et fermentum tortor. Nam elementum augue ex, at tempus nunc cursus eget. Proin nec quam felis. Cras quis felis porta, ultricies orci at, mollis tortor."]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        table.dataSource = self
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

extension TestController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = table.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MyCellViewCell
               
        let currentCard = content[indexPath.row]
        
        cell.label.text = currentCard
        cell.updateUI()

        return cell
    }
}
