//
//  ConvertorViewController.swift
//  BitTracker
//
//  Created by Rauan on 10/6/19.
//  Copyright © 2019 Rauan. All rights reserved.
//

import UIKit

class ConvertorViewController: UIViewController {
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var bitCointTextField: UITextField!
    
    @IBOutlet weak var currencyLabel: UILabel!
    private var currencyValue : CurrencyValue = .KZT{
        didSet{
            currencyLabel.text = currencyValue.getValue()
        }
    }
    private var currency : Currency?
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyTextField.delegate = self
        currencyTextField.tag = 1
        bitCointTextField.delegate = self
        bitCointTextField.tag = 0
        getCurrency()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapEndEditing))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func tapEndEditing() {
        self.view.endEditing(true)
        self.view.becomeFirstResponder()
    }
    
    private func getCurrency() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.mainService.getCurrency(currency: currencyValue.getValue()) {
            [weak self](result) in
            guard let strongSelf = self else {return}
            switch result {
            case let .success(currency):
                strongSelf.currency = currency
                if strongSelf.currencyTextField.isFirstResponder {
                    strongSelf.calculateCurrency(tag: 1, amount: strongSelf.currencyTextField.text ?? "")
                } else {
                    strongSelf.calculateCurrency(tag: 0, amount: strongSelf.bitCointTextField.text ?? "")
                }
                
            case let .failure(error):
                print(error)
                return
            }
        }
    }
    private func calculateCurrency(tag: Int, amount: String) {
        if amount == "" {
            bitCointTextField.text = ""
            currencyTextField.text = ""
            return
        }
        let doubleAmount = Double(amount)!
        guard let rate = currency?.rate_float else {return}
        if tag == 0 {
            let currency = doubleAmount * rate
            currencyTextField.text = "\(round(currency * 10000) / 10000)"
        } else if tag == 1{
            let currency = doubleAmount / rate
            bitCointTextField.text = "\(round(currency * 100000000) / 100000000)"
        }
    }
    
    @IBAction func segmentControllerChanged(_ sender: Any) {
        currencyValue = segmentController.selectedSegmentIndex == 0 ? .KZT : segmentController.selectedSegmentIndex == 1 ? .USD : .EUR
        getCurrency()
    }


}
extension ConvertorViewController : UITextFieldDelegate {
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if string != "" {
                calculateCurrency(tag: textField.tag, amount: textField.text! + string)
            } else {
                if textField.text!.contains("e") {
                    let double = Double(textField.text!)! * 10
                    textField.text = String(double)
                    calculateCurrency(tag: textField.tag, amount: String(double))
                    return false
                } else {
                    let text = textField.text!.dropLast()
                    calculateCurrency(tag: textField.tag, amount: String(text))
                }
                
            }
            
        return true
    }
}
