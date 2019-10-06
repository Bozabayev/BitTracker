//
//  CurrencyTableViewCell.swift
//  BitTracker
//
//  Created by Rauan on 10/4/19.
//  Copyright © 2019 Rauan. All rights reserved.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {

    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyValueLabel: UILabel!
    @IBOutlet weak var segmentController: UISegmentedControl!
    // Здесть я решил использовать closure, так как напрямую связаны с местом доставки
    public var currencyChanged: ((Int)->())!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // Initialization code
    }

    @IBAction func segmentControllerChanged(_ sender: Any) {
        currencyChanged(segmentController.selectedSegmentIndex)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
