//
//  SimpleCalculator.swift
//  KellyShop
//
//  Created by Hai Lu on 4/3/16.
//  Copyright © 2016 Hai Lu. All rights reserved.
//

import Foundation
import UIKit

class SimpleCalculator : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtShopPrice: UITextField!
    @IBOutlet weak var stepperPrice: UIStepper!
    
    @IBOutlet weak var lblSellPrice: UILabel!
    @IBOutlet weak var lblBasePrice: UILabel!
    @IBOutlet weak var lblTransferPrice: UILabel!
    
    @IBOutlet weak var lblEarnPrice: UILabel!
    var price:Double = 0
    
    @IBOutlet weak var lblEarnPriceTransfer: UILabel!
    @IBAction func stepperChanged(sender: UIStepper) {
        price = sender.value
        updateValue()
    }
    
    @IBAction func txtPriceChanged(sender: UITextField) {
        Logger.log("txt price changed")
        if sender.text! != "" {
            price = Double(sender.text!)!
        } else {
            price = 0
        }
        updateValue()
            
    }
    
    func updateValue() {
        stepperPrice.value = price
        txtShopPrice.text = String(Int(price))
        var b:Double = 0
        if price > 300 {
            b = 80
        } else if price > 250 {
            b = 60
        } else if price > 200 {
            b = 50
        } else if price > 120 {
            b = 40
        } else {
            b = 30
        }
        var c = 90 - b
        var ct = c - 40
        if price <= 120 {
            c = 50 - b
            ct = c - 25
        }
        self.lblBasePrice.text = String(Int(price - b))
        self.lblSellPrice.text = String(Int(price + c))
        self.lblTransferPrice.text = String(Int(price + ct))
        self.lblEarnPrice.text = String(Int(c + b))
        self.lblEarnPriceTransfer.text = String(Int(ct + b))
    }
    
    override func viewDidLoad() {
        txtShopPrice.addTarget(self, action: #selector(SimpleCalculator.txtPriceChanged(_:)), forControlEvents: UIControlEvents.EditingChanged)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}