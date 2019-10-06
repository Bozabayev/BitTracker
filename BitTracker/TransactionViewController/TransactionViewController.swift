//
//  TransactionViewController.swift
//  BitTracker
//
//  Created by Rauan on 10/6/19.
//  Copyright © 2019 Rauan. All rights reserved.
//

import UIKit

class TransactionViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var transactions : [Transaction] = []
    private var refreshController = UIRefreshControl()
    // Я решил добавить пагинацию, 5 страниц по 100 трансакций
    private var page = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TransactionTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionTableViewCell")
        tableView.separatorStyle = .none
        refreshController.addTarget(self, action: #selector(refreshTransactions), for: .valueChanged)
        tableView.refreshControl = refreshController
        page = 1
        getTransactions(page: 1)
    }
    // Обновляем трансакции свайпом вниз
     @objc private func refreshTransactions() {
        transactions = []
        page = 1
        getTransactions(page: 1)
        refreshController.beginRefreshing()
    }
    
    private func getTransactions(page: Int?) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.mainService.getTransactions(page: page) { [weak self](result) in
            guard let strongSelf = self else {return}
            
            switch result {
            case let .success(transaction):
                // Отключаем анимацию чтобы при reloadData tableView не убежал куда нибудь (contentOffset поменялся соответсвенно новым сторокам без анимации и разрывов)
                UIView.setAnimationsEnabled(false)
                strongSelf.transactions += transaction
                strongSelf.refreshController.endRefreshing()
                strongSelf.tableView.reloadData()
                UIView.setAnimationsEnabled(true)
            case let .failure(error):
                strongSelf.refreshController.endRefreshing()
                print(error)
            }
        }
    }
 
}

extension TransactionViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as! TransactionTableViewCell
        if page < 5 && indexPath.row > page * 80 {
            page += 1
            getTransactions(page: page)
        }
        guard transactions.count > 0 else {return cell}
        cell.dateLabel.text = transactions[indexPath
            .row].date?.getStringDateFromTimeStamp()
        cell.typeLabel.text = transactions[indexPath.row].type == 0 ? "Покупка": "Продажа"
        cell.bitPriceLabel.text = transactions[indexPath.row].amount
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "TransactionDescribeViewController") as! TransactionDescribeViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.transaction = transactions[indexPath.row]
        self.present(vc, animated: true, completion: nil)
    }
    
    
}
