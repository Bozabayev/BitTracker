//
//  TransactionDescribeViewController.swift
//  BitTracker
//
//  Created by Rauan on 10/6/19.
//  Copyright © 2019 Rauan. All rights reserved.
//

import UIKit

class TransactionDescribeViewController: UIViewController {

    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    public var transaction : Transaction?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.5254417062, green: 0.5223218203, blue: 0.5278422236, alpha: 0.25)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapPressed))
        self.view.addGestureRecognizer(tap)
        bottomView.layer.cornerRadius = 10
        bottomView.layer.borderWidth = 0.75
        bottomView.layer.borderColor = UIColor.init(patternImage: #imageLiteral(resourceName: "024 Near Moon-1")).cgColor
        bottomView.backgroundColor = #colorLiteral(red: 0.9561085105, green: 0.9504246116, blue: 0.960477531, alpha: 1)
        setupView()
        // Do any additional setup after loading the view.
    }
    
   private func setupView() {
        guard  let transaction = transaction else {return }
        idLabel.text = "ID: \(String(describing: transaction.tid!))"
        typeLabel.text = transaction.type == 0 ? "ПОКУПКА" : "ПРОДАЖА"
        let date = transaction.date?.getStringDateFromTimeStamp()
        dateLabel.text = date
        amountLabel.text = transaction.amount
        currencyLabel.text = "=  \(transaction.price!)"
        let price = round((Double(transaction.price!)! * Double(transaction.amount!)!) * 10000) / 10000
        priceLabel.text = "\(price)"
    }
    
    
    @objc func tapPressed() {
        self.dismiss(animated: true, completion: nil)
    }

}
