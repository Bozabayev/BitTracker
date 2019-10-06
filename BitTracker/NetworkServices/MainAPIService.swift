//
//  MainAPIService.swift
//  BitTracker
//
//  Created by Rauan on 10/6/19.
//  Copyright © 2019 Rauan. All rights reserved.
//


import Foundation
import Alamofire
import SwiftyJSON

protocol MainAPIProtocols {
    func getCurrency(currency: String?,_ completion : @escaping (Result<Currency,MyError>) -> ())
    func getCurrencyHistory(currency: String?, start: String?, end :String?, _ completion: @escaping (Result<DateCurrency,MyError>)->())
    func getTransactions(page: Int?,_ completion: @escaping (Result<[Transaction],MyError>)->())
}


class MainAPIService : MainAPIProtocols  {
    
    
    func getTransactions(page: Int?,_ completion: @escaping (Result<[Transaction],MyError>)->()) {
        let APIMethod = MainAPI.getTransactions(page: page)
                APIMethod.request().responseJSONWithErrorHandling { (json, meta, error) -> (Void) in
            if let json = json {
                let data = try! JSONDecoder().decode([Transaction].self, from: json.rawData())
                completion(.success(data))
                return
            }
            if let error = error {
                completion(.failure(error))
                return
            }
        }
    }
    func getCurrencyHistory(currency: String?, start: String?, end: String?, _ completion: @escaping (Result<DateCurrency, MyError>) -> ()) {
        let APIMethod = MainAPI.getCurrencyHistory(currency:currency,start:start,end:end)
        APIMethod.request().responseJSONWithErrorHandling { (json, meta, error) -> (Void) in
            if let json = json {
                let data = try! JSONDecoder().decode(DateCurrency.self, from: json.rawData())
                completion(.success(data))
                return
            }
            if let error = error {
                completion(.failure(error))
                return
            }
        }
    }
    
    func getCurrency(currency: String?, _ completion: @escaping (Result<Currency, MyError>) -> ()) {
        let APIMethod = MainAPI.getCurrency(currency: currency)
        APIMethod.request().responseJSONWithErrorHandling { (json, meta, error) -> (Void) in
            if let json = json {
                let data = try! JSONDecoder().decode(Currency.self, from: json.rawData())
                completion(.success(data))
                return
            }
            if let error = error {
                completion(.failure(error))
                return
            }
        }
    }
    

    

    
    
}

