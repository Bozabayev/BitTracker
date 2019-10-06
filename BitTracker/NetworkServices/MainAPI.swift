//
//  MainAPI.swift
//  BitTracker
//
//  Created by Rauan on 10/6/19.
//  Copyright © 2019 Rauan. All rights reserved.
//

import Foundation



import Foundation
import Alamofire

struct MainUrls {
    let coinAPI = "https://api.coindesk.com/v1/bpi"
    let transactionAPI = "https://www.bitstamp.net/api"
}

enum MainAPI : URLConvertible, URLRequestConvertible {
    
    case getCurrency(currency: String?)
    case getCurrencyHistory(currency:String?,start: String?, end: String?)
    case getTransactions(page:Int?)
    
    func asURL() throws -> URL {
        return URL(string: URLString)!
    }
    
    var URLString: String {
        switch self {
        case .getCurrency,.getCurrencyHistory:
            return MainUrls().coinAPI + path
        case .getTransactions:
            return MainUrls().transactionAPI + path
        }
        
    }
    
    var headers: [String: String] {
        var parameters: [String: String] = [:]
        
        parameters["Accept"] = "application/json"
        parameters["Contept-Type"] = "application/json"
        
        return parameters
    }
    
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: try! URLString.asURL())
        request.httpMethod = method.rawValue
        for (headerField, headerValue) in headers {
            request.setValue(headerValue, forHTTPHeaderField: headerField)
        }
        return request
    }
    
    
    var path: String {
        switch self {
        case let .getCurrency(currency):
            return "/currentprice/\(String(describing: currency!)).json"
        case .getCurrencyHistory:
            return "/historical/close.json"
        case .getTransactions:
            return "/transactions/"
        }
    }
    
    
    var method: HTTPMethod {
        switch self {
        case .getCurrency,.getCurrencyHistory,.getTransactions:
            return .get
        }
    }
    
    var parameters: [String: AnyObject] {
        var parameters: [String: AnyObject] = [:]
        switch self {
        case let .getCurrencyHistory(currency,start,end):
            parameters["currency"] = currency as AnyObject?
            parameters["start"] = start as AnyObject?
            parameters["end"] = end as AnyObject?
            return parameters
        case let .getTransactions(page):
            parameters["page"] = page as AnyObject?
            parameters["time"] = "day" as AnyObject?
            return parameters
        case .getCurrency:
            return parameters
        }
    }
    
    
    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.queryString
            
        case .post:
            return JSONEncoding.prettyPrinted
            
        case .put:
            return JSONEncoding.prettyPrinted
            
        case .delete:
            return URLEncoding.queryString
            
        default:
            fatalError("kFatalErrorMessage")
        }
    }
    
    func request() -> DataRequest {
        let encodedURLRequest = try! encoding.encode(try! asURLRequest(), with: parameters)
        return SessionManager.`default`.request(encodedURLRequest)
    }
    
}
