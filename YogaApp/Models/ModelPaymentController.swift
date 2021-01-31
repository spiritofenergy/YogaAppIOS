//
//  ModelPaymentController.swift
//  YogaApp
//
//  Created by Nill Simon on 31.01.2021.
//  Copyright © 2021 Nill Simon. All rights reserved.
//

import UIKit
import YooKassaPayments
import YooKassaPaymentsApi
import Firebase

class ModelPaymentController: NSObject {
    
    static let payment: ModelPaymentController = ModelPaymentController()
    
    var email = "nigmatullov@mail.ru"
    var phone = ""
    
    var responceURL: String? = nil
    
    func sendToken(token: Tokens, paymentMethodType: PaymentMethodType, price: Double) {
        if let user = Auth.auth().currentUser {
            email = user.email != nil ? user.email! : ""
            phone = user.phoneNumber != nil ? user.phoneNumber! : ""
        }
        
        let postString = "promo=\(token.paymentToken)&type=\(paymentMethodType.rawValue.lowercased())&price=\(price)0&email=\(email)&phone=\(phone)"
        
        let url = URL(string: "https://api.seostor.ru/sendPromo.php?\(postString)")!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(error!)")
                return
            }

            let responseString = String(data: data, encoding: .utf8)
            self.responceURL = responseString
            
            NotificationCenter.default.post(name: NSNotification.Name("open3ds"), object: self)
            
            print("responseString = \(responseString!)")
        }
        task.resume()
    }
    
}
