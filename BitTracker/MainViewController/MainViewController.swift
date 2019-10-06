//
//  MainViewController.swift
//  BitTracker
//
//  Created by Rauan on 10/4/19.
//  Copyright © 2019 Rauan. All rights reserved.
//

import UIKit


// Я предпочитаю как можно часто использовать перечесления(enum)
enum CurrencyValue {
    case KZT
    case USD
    case EUR
    
    func getValue() -> String {
        switch self {
        case .KZT:
            return "KZT"
        case .EUR:
            return "EUR"
        case .USD:
            return "USD"
        }
    }
}

enum TimeFilter {
    case week
    case month
    case year
}

class MainViewController: UIViewController, TimeFilterChangedDelegate{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    private var currency : Currency?
    private var currencies : [Double] = []
    private var dates : [String] = []
    private var highestCurrency = 0.0
    private var currencyValue : CurrencyValue = .KZT {
        didSet {
            getCurrency()
            getCurrencyHistory()
        }
    }
    private var timeFilter : TimeFilter = .week {
        didSet {
            getCurrencyHistory()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getCurrency()
        getCurrencyHistory()
    }
    
    
    // Я предпочитаю работать через XIBы, строя свой UI через TableView и TableViweCell, тем самым разбивая UI на блоки которые легко переиспользуются. В данном конкретном случае использование напрямую Storyboard было бы намного эффективней и быстрей, но я решил показать к каким методам я привык.
   private func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "CurrencyTableViewCell", bundle: nil), forCellReuseIdentifier: "CurrencyTableViewCell")
    tableView.register(UINib(nibName: "CurrencyLineChartTableViewCell", bundle: nil), forCellReuseIdentifier: "CurrencyLineChartTableViewCell")
    }
    
   private func getCurrency() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.mainService.getCurrency(currency: currencyValue.getValue()) {
            [weak self](result) in
            guard let strongSelf = self else {return}
            switch result {
            case let .success(currency):
                strongSelf.currency = currency
                strongSelf.tableView.reloadData()
            case let .failure(error):
                print(error)
                return
            }
        }
    }
    
    // В данном запросе я пошел на небольшое упрошение в цифрах так месяц состоит из 28 дней
    private func getCurrencyHistory() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var start = ""
        let calendar = Calendar.current
        switch timeFilter {
        case .week:
            let dateComponents = DateComponents(year: calendar.component(.year, from: Date()), month: calendar.component(.month, from: Date()), day: calendar.component(.day, from: Date()) - 7)
            let date = calendar.date(from: dateComponents)!
            start = dateFormatter.string(from: date)
        case .month:
             let dateComponents = DateComponents(year: calendar.component(.year, from: Date()), month: calendar.component(.month, from: Date()), day: calendar.component(.day, from: Date()) - 28)
            let date = calendar.date(from: dateComponents)!
            start = dateFormatter.string(from: date)
        case .year:
            let dateComponents = DateComponents(year: calendar.component(.year, from: Date()) - 1, month: calendar.component(.month, from: Date()), day: calendar.component(.day, from: Date()))
            let date = calendar.date(from: dateComponents)!
            start = dateFormatter.string(from: date)
        }
        let end = dateFormatter.string(from: Date())
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.mainService.getCurrencyHistory(currency: self.currencyValue.getValue(), start: start, end: end) { (result) in
            switch result {
            case let .success(dateCurrency):
                self.getCoordinates(dateCurrency: dateCurrency)
            case let .failure(error):
                print(error)
            }
        }
    }
// С API данные приходят как Dictionary так что приходится упорядочить все по датам
    private func getCoordinates(dateCurrency: DateCurrency) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let calendar = Calendar.current
        var currenciesCorrect : [Double] = []
        var datesCorrect : [String] = []
            for (index, _) in (dateCurrency.bpi?.enumerated())!{
                let dateComponents = DateComponents(year: calendar.component(.year, from: Date()), month: calendar.component(.month, from: Date()), day: calendar.component(.day, from: Date()) - index - 1)
                let date = calendar.date(from: dateComponents)!
                let stringDate = dateFormatter.string(from: date)
                currenciesCorrect.append((dateCurrency.bpi?[stringDate])!)
                datesCorrect.append(stringDate)
            }
        // Я решил отдельно реверсировать массив уже после его построения, хоть и пришлось писать два цикла, по моему так будет лучше
        var reversedCurrencies : [Double] = []
        var reversedDates : [String] = []
        for arrayIndex in stride(from: currenciesCorrect.count - 1, through: 0, by: -1) {
            reversedCurrencies.append(currenciesCorrect[arrayIndex])
        }
        for arrayIndex in stride(from: datesCorrect.count - 1, through: 0, by: -1) {
            reversedDates.append(datesCorrect[arrayIndex])
        }
        var rate = 0.0
        var date = ""
        var rates : [Double] = []
        var dates : [String] = []
        highestCurrency = 0.0
        switch timeFilter {
        case .week:
            for i in reversedCurrencies {
                highestCurrency = i > highestCurrency ? i : highestCurrency
            }
            self.dates = reversedDates
            self.currencies = reversedCurrencies
        case .month:
            for i in 1...4 {
                for x in 1...7 {
                    rate += reversedCurrencies[i*x - 1]
                    if x == 1 || x == 7 {
                        date += x == 1 ? reversedDates[(i*x - 1)*7] : " -> \(reversedDates[i*x - 1])"
                    }
                }
                highestCurrency = (rate / 7) > highestCurrency ? (rate / 7) : highestCurrency
                rates.append(rate / 7)
                dates.append(date)
                rate = 0.0
                date = ""
            }
            self.currencies = rates
            self.dates = dates
        case .year:
            for i in 1...12 {
                for x in 1...30 {
                    rate += reversedCurrencies[i*x - 1]
                    if x == 1 || x == 30 {
                        date += x == 1 ? reversedDates[(i*x - 1)*30] : " -> \(reversedDates[i*x - 1])"
                    }
                }
                 highestCurrency = (rate / 30) > highestCurrency ? (rate / 30) : highestCurrency
                rates.append(rate / 30)
                dates.append(date)
                rate = 0.0
                date = ""
            }
            self.currencies = rates
            self.dates = dates
        }
        self.tableView.reloadData()
}
    // Функций протокольного делегирования
    func timeFilterChanged(index: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.timeFilter = index == 0 ? .week : index == 1 ? .month : .year
        }
    }
    
}
extension MainViewController : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch  indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyTableViewCell", for: indexPath) as! CurrencyTableViewCell
            cell.segmentController.selectedSegmentIndex = currencyValue == .KZT ? 0 : currencyValue == .USD ? 1 : 2
            cell.currencyLabel.text = self.currencyValue.getValue()
            cell.currencyChanged = { (index) in
            // Я решил добавить задержку по времени равную стандортному времени анимации в iOS чтобы анимация segmetController-а не обрывалась
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.currencyValue = index == 0 ? .KZT : index == 1 ? .USD : .EUR
                }
            }
            guard let rate = self.currency?.rate else {return cell}
            cell.currencyValueLabel.text = "=  \(String(describing: rate))"
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyLineChartTableViewCell", for: indexPath) as! CurrencyLineChartTableViewCell
            cell.lineChartView.currencies = self.currencies
            cell.lineChartView.highestCurrency = self.highestCurrency
            cell.lineChartView.timeFilter = self.timeFilter
            cell.lineChartView.currencyValue = self.currencyValue
            cell.dates = self.dates
            cell.currencies = self.currencies
            cell.currencyValue = self.currencyValue
            cell.timeFilterChanged = self
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 110
        case 1:
            return 280
        default:
            return 0
        }
    }
}
