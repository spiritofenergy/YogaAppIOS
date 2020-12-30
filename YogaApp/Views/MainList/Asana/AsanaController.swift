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
    @IBOutlet var imageSliderIn: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleAsana.text = card?.title
        descAsana.text = card?.description
        
        navigationItem.title = card?.title
        
        imageSliderIn.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateUI()
    }

    func updateUI() {
        DispatchQueue.main.async {
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
    }
}

extension AsanaController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return card!.thumbPath!.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageSliderIn.dequeueReusableCell(withReuseIdentifier: "imageSliderIn", for: indexPath) as! ImageOfSlider
        
        cell.initCellIn(path: card!.thumbPath![indexPath.row])
        
        return cell
    }
}
