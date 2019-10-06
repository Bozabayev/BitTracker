//
//  TransactionTableViewCell.swift
//  BitTracker
//
//  Created by Rauan on 10/6/19.
//  Copyright © 2019 Rauan. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bitPriceLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        bottomView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        bottomView.layer.borderWidth = 0.75
        bottomView.layer.borderColor = #colorLiteral(red: 0.5215686275, green: 0.6117647059, blue: 0.6352941176, alpha: 1)
        bottomView.layer.cornerRadius = 10
        bottomView.layer.shadowColor = #colorLiteral(red: 0.1824130118, green: 0.181335479, blue: 0.1832456887, alpha: 0.8409139555)
        bottomView.layer.shadowRadius = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
