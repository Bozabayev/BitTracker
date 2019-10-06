//
//  CurrencyLineChartTableViewCell.swift
//  BitTracker
//
//  Created by Rauan on 10/4/19.
//  Copyright © 2019 Rauan. All rights reserved.
//

import UIKit
protocol TimeFilterChangedDelegate {
    func timeFilterChanged(index: Int)
}

class CurrencyLineChartTableViewCell: UITableViewCell {

    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    // Я решил написать линейный график самостоятельно без сторонних библиотек, но он был создан на скорую руку и исключетельно под мои задачи
    @IBOutlet weak var lineChartView: LineChart!
    @IBOutlet weak var segmentController: UISegmentedControl!
    // Как альтернатива closure который был использован в CurrencyTableViewCell здесь я использовал протоколное делегирование
    public var timeFilterChanged : TimeFilterChangedDelegate!
    public var dates : [String] = []
    public var currencies : [Double] = []
    public var currencyValue : CurrencyValue = .KZT
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        infoView.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(showInfo), name: .showInfo, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideInfo), name: .hideInfo, object: nil)
        // Initialization code
    }
    // Отображаем данные за определенный период, когда линейка подойдет к точке(смотреть LineChart)
    @objc func showInfo(_ notification: NSNotification) {
        let index = notification.object as! Int
        if infoView.isHidden == true {
            infoView.isHidden = false
            currencyLabel.text = "\(currencies[index].rounded()) \(currencyValue.getValue())"
            dateLabel.text = dates[index]
        }
    }
    // Скрываем информационное окно
    @objc func hideInfo() {
            infoView.isHidden = true
    }
    
    
    @IBAction func segmentControllerChanged(_ sender: Any) {
        self.timeFilterChanged.timeFilterChanged(index: segmentController.selectedSegmentIndex)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
