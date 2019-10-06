//
//  Request.swift
//  BitTracker
//
//  Created by Rauan on 10/6/19.
//  Copyright © 2019 Rauan. All rights reserved.
//

import Foundation




import Alamofire
import SwiftyJSON



extension DataRequest {
    
    @discardableResult func responseJSONWithErrorHandling(_ completionHandler: @escaping (_ data: JSON?, _ meta:JSON?, _ error: MyError?) -> (Void))
        -> Self
    {
        return responseJSON(completionHandler: { (response) in
            var output = ""
            
            output.append("################ REQUEST ################")
            if let request = response.request {
                output.append("\n")
                output.append("URL:")
                output.append(request.url?.absoluteString ?? "UNKNOWN")
                
                output.append("\n")
                output.append("Method:")
                output.append(request.httpMethod ?? "UNKNOWN")
                
                output.append("\n")
                output.append("Headers:")
                if let allHTTPHeaderFields = request.allHTTPHeaderFields {
                    output.append("\(allHTTPHeaderFields)")
                } else {
                    output.append("NULL")
                }
                
                
                if request.httpMethod == "POST" || request.httpMethod == "DELETE" {
                    output.append("\n")
                    output.append("Body:")
                    if let HTTPBody = request.httpBody {
                        let dataString = String(data: HTTPBody, encoding: String.Encoding.utf8)
                        if let dataString = dataString {
                            output.append(dataString)
                        } else {
                            output.append("Not Parsed")
                        }
                    } else {
                        output.append("NULL")
                    }
                }
            }
            
            output.append("\n")
            output.append("################ RESPONSE ################")
            switch response.result {
            case let .success(value):
                let json = JSON(value)
                output.append("\n")
                output.append("\(json)")
                if (json["bpi"] != JSON.null) {
                    let innerJSON = json["bpi"]
                    if (innerJSON["KZT"] != JSON.null) {
                        completionHandler(innerJSON["KZT"],nil,nil)
                        return
                    } else if (innerJSON["EUR"] != JSON.null) {
                        completionHandler(innerJSON["EUR"],nil,nil)
                        return
                    } else if (innerJSON["USD"] != JSON.null) {
                        completionHandler(innerJSON["USD"],nil,nil)
                        return
                    } else {
                        completionHandler(json,nil,nil)
                        return
                    }
                } else {
                    completionHandler(json,nil,nil)
                    return
                }
                
            case  .failure(let error):
                DCPrint(error)
                
                if(error as? AFError == nil)
                {
                    //let d = String.init(data: response.data!, encoding: .utf8)
                    let _error = MyError.networkError(reason: .api(title: "Проблема с сервером", subtitle: nil, code: 123))
                    //DCPrint(output)
                    completionHandler(nil, nil, _error)
                    
                    return;
                }
                let error = error as? AFError
                guard let responseCode = error?.responseCode else {
                    //let d = String.init(data: response.data!, encoding: .utf8)
                    
                    let title = error?.errorDescription!
                    let subtitle: String? = nil
                    let code = 0
                    let _error = MyError.networkError(reason: .api(title: title!, subtitle: subtitle, code: code))
                    //DCPrint(output)
                    completionHandler(nil, nil, _error)
                    return
                }
                
                self.validateHTTPError(responseCode, output: &output, response: response, error: error!)
                
                output.append("\n")
                output.append("################ MUST SHOW ERROR MESSAGE ################")
                
                let title = error?.errorDescription!
                let subtitle: String? = nil
                let code = responseCode
                let _error = MyError.networkError(reason: .api(title: title!, subtitle: subtitle, code: code))
                //DCPrint(output)
                completionHandler(nil, nil, _error)
            }
        })
    }
    
    func validateServerError(_ code: Int, output: inout String) {
        output.append("\n")
        switch code {
        case 400:
            output.append("Bad Request")
        case 401:
            output.append("Unauthorized")
        case 403:
            output.append("Forbidden")
        case 404:
            output.append("Not Found")
        case 408:
            output.append("Refresh token")
        case 500:
            output.append("Internal Server Error")
        case 502:
            output.append("Bad Gateway")
        case 503:
            output.append("Service Unavaliable")
        case 504:
            output.append("Gateway Timeout")
            
        default:
            output.append("Unknown state with code: \(code)")
        }
    }
    
    func validateHTTPError(_ code: Int, output: inout String, response: DataResponse<Any>, error: AFError) {
        output.append("\n")
        switch code {
        case 400:
            output.append("Bad Request")
        case 401:
            output.append("Unauthorized")
        case 403:
            output.append("Forbidden")
        case 404:
            output.append("Not Found")
        case 408:
            output.append("Request timeout")
            
        case 500:
            output.append("Internal Server Error")
        case 502:
            output.append("Bad Gateway")
        case 503:
            output.append("Service Unavaliable")
        case 504:
            output.append("Gateway Timeout")
            
        case 3840:
            output.append("Response is not valid JSON")
            
            output.append("\n")
            output.append("Headers:")
            if let allHTTPHeaderFields = response.response?.allHeaderFields {
                output.append("\(allHTTPHeaderFields)")
            } else {
                output.append("NULL")
            }
            output.append("\n")
            if let data = response.data {
                let dataString = String(data: data, encoding: String.Encoding.utf8)
                let def = ""
                output.append("Data: \(dataString ?? def)")
            } else {
                output.append("Data: NULL")
            }
        case -999:
            output.append("Request Cancelled")
            
        default:
            output.append("Unknown state with error: \(error)")
        }
    }
}
