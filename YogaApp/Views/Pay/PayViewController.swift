//
//  PayViewController.swift
//  YogaApp
//
//  Created by Nill Simon on 18.01.2021.
//  Copyright © 2021 Nill Simon. All rights reserved.
//

import UIKit
import YooKassaPayments
import YooKassaPaymentsApi

class PayViewController: UIViewController {
    
    @IBOutlet weak var useBtn: UIButton!
    @IBOutlet weak var promoTxtBox: UITextField!
    @IBOutlet weak var promocode: UILabel!
    @IBOutlet weak var sale: UILabel!
    @IBOutlet weak var times: UILabel!
    @IBOutlet weak var titleUses: UILabel!
    @IBOutlet weak var titleSale: UILabel!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var titleTimes: UILabel!
    @IBOutlet weak var buyBtn: UIButton!
    @IBOutlet weak var pricePrreviewLbl: UILabel!
    @IBOutlet weak var salePreviewLbl: UILabel!
    
    private let price = 1600
    private var totalPrice = 1600s
    
    private var tokenizationViewController: (TokenizationModuleInput & UIViewController)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("updateUserPromo"), object: nil, queue: nil) { (notification) in
            self.titleUses.text = "Вы уже использовали промокод"
            self.promoTxtBox.text = ModelFireBaseDB.objectDB.user.usedPromo
            self.promoTxtBox.isEnabled = false
            self.useBtn.isEnabled = false
            
            self.setBuyOption()
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("open3ds"), object: nil, queue: nil) { (notification) in
            self.needsConfirmPayment(requestUrl: ModelPaymentController.payment.responceURL ?? "")
        }

        let promo = ModelFireBaseDB.objectDB.user.promocode
        
        promocode.text = promo != nil ? promo : "..."
        sale.text = "\(ModelFireBaseDB.objectDB.user.sale) %"
        times.text = "\(ModelFireBaseDB.objectDB.user.usesPromo)"
        
        if ModelFireBaseDB.objectDB.user.usedPromo == nil {
            titleUses.text = "Вы ещё не использовали промокод"
            
        } else {
            titleUses.text = "Вы уже использовали промокод"
            promoTxtBox.text = ModelFireBaseDB.objectDB.user.usedPromo
            promoTxtBox.isEnabled = false
            useBtn.isEnabled = false
        }
        
        setBuyOption()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateUI()
    }
    
    @IBAction func useAction(_ sender: Any) {
        promoTxtBox.endEditing(true)
        
        if promoTxtBox.text != nil && promoTxtBox.text != ModelFireBaseDB.objectDB.user.usedPromo {
            ModelFireBaseDB.objectDB.setPromo(promo: promoTxtBox.text!)
        }
    }
    

    @IBAction func copyAction(_ sender: Any) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = promocode.text
        
        let toast = UILabel(frame: CGRect(x: view.frame.size.width / 2 - 150, y: view.frame.size.height - 130, width: 300, height: 35))
        toast.text = "Промокод успешно скопирован"
        toast.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toast.textColor = UIColor.white
        toast.textAlignment = .center
        toast.alpha = 1.0
        toast.layer.cornerRadius = 10
        toast.clipsToBounds = true
        
        view.addSubview(toast)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toast.alpha = 0.0
        }) { (isCompleted) in
            toast.removeFromSuperview()
        }
    }
    
    @IBAction func byaAct(_ sender: Any) {
        
        let clientApplicationKey = "live_Nzc2MjgzR2lAM1Gh5j-sBtKgLhfhg-YWqdnf-CWDEM0"
        let amount = Amount(value: Decimal(totalPrice), currency: .rub)
        let tokenizationSettings = TokenizationSettings(paymentMethodTypes: [.bankCard])
        
        let tokenizationModuleInputData =
        TokenizationModuleInputData(clientApplicationKey: clientApplicationKey,
                                    shopName: "Видеокурс по йоге",
                                    purchaseDescription: """
                                                          8 онлайн занятий йоги с инструктором
                                                          """,
                                    amount: amount,
                                    tokenizationSettings: tokenizationSettings,
                                    savePaymentMethod: .off)
        let inputData: TokenizationFlow = .tokenization(tokenizationModuleInputData)
        
        self.tokenizationViewController = TokenizationAssembly.makeModule(inputData: inputData,
                                                                         moduleOutput: self)
        present(self.tokenizationViewController!, animated: true, completion: nil)
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
            self.promocode.textColor = Theme.current.textColor
            self.sale.textColor = Theme.current.textColor
            self.times.textColor = Theme.current.textColor
            self.titleUses.textColor = Theme.current.textColor
            self.titleSale.textColor = Theme.current.textColor
            self.titleTimes.textColor = Theme.current.textColor
            self.mainTitle.textColor = Theme.current.textColor
        }
    }
    
    private func setBuyOption() {
        let saleCur = ModelFireBaseDB.objectDB.user.sale
        
        if (saleCur > 0) {
            totalPrice = price - (price * saleCur / 100)
            pricePrreviewLbl.text = "\(totalPrice).00 р."
            
            salePreviewLbl.isHidden = false
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "1600.00 р.")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            salePreviewLbl.attributedText = attributeString
        }
    }
    
    func needsConfirmPayment(requestUrl: String) {
        self.tokenizationViewController!.start3dsProcess(requestUrl: requestUrl)
    }
    
}

extension PayViewController : TokenizationModuleOutput {
    func tokenizationModule(_ module: TokenizationModuleInput,
                            didTokenize token: Tokens,
                            paymentMethodType: PaymentMethodType) {
        
        ModelPaymentController.payment.sendToken(token: token, paymentMethodType: paymentMethodType, price: Double(totalPrice))
    }

    func didFinish(on module: TokenizationModuleInput,
                   with error: YooKassaPaymentsError?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
    }

    func didSuccessfullyPassedCardSec(on module: TokenizationModuleInput) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let alert = UIAlertController(title: "Статус платежа", message: "Платеж успешный", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            self.dismiss(animated: true)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}
