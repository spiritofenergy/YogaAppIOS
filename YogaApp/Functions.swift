//
//  Functions.swift
//  YogaApp
//
//  Created by Nill Simon on 02.12.2020.
//  Copyright © 2020 Nill Simon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

extension UIImageView {
    func load(url: URL?) {
        DispatchQueue.global().async { [weak self] in
            if let url = url {
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.image = image
                        }
                    }
                }
            }
        }
    }
}

func getImage(url: String.SubSequence, comletion: @escaping (UIImage?) -> ()) {
    let storage = Storage.storage().reference()
    
    let filePath = "\(url).jpeg"
    let fileURL = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!).appendingPathComponent(filePath)
    
    let storageRef = storage.child("thumbnails/\(url).jpeg")
    
    if let imageData = NSData(contentsOf: fileURL!) {
        let image = UIImage(data: imageData as Data)
        
        comletion(image)
    } else {
        storageRef.write(toFile: fileURL!) { url, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let imageData = NSData(contentsOf: fileURL!) {
                    let image = UIImage(data: imageData as Data)
                    
                    comletion(image)
                } else {
                    comletion(nil)
                }
            }
        }
    }
}
