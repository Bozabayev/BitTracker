//
//  Result.swift
//  BitTracker
//
//  Created by Rauan on 10/6/19.
//  Copyright © 2019 Rauan. All rights reserved.
//

import Foundation


typealias ResultSuccess = Result<Success, MyError>
typealias ResultSuccessCompletion = (Result<Success, MyError>) -> ()


enum Result<Value, Err: Error> {
    case success(Value)
    case failure(Err)
}

struct Success {
    
}

struct Failure: Error {
    
}
