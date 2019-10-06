//
//  MyError.swift
//  BitTracker
//
//  Created by Rauan on 10/6/19.
//  Copyright © 2019 Rauan. All rights reserved.
//

import Foundation


enum MyError: Error {
    enum Network {
        case unauthorized
        case api(title: String, subtitle: String?, code: Int)
    }
    
    enum Internal {
        
    }
    
    enum Storage {
        
    }
    
    case text(string: String)
    case error(error: NSError)
    case networkError(reason: Network)
    case internalError(reason: Internal)
    case storageError(reason: Storage)
    
}

extension MyError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .error(let error):
            return error.localizedDescription
            
        case .text(let string):
            return string
            
        case .networkError(let reason):
            return reason.errorDescription
            
        case .internalError(let reason):
            return reason.errorDescription
            
        case .storageError(let reason):
            return reason.errorDescription
        }
    }
    
    var failureReason: String? {
        switch self {
        case .error(let error):
            return error.localizedFailureReason
            
        case .text:
            return nil
            
        case .networkError(let reason):
            return reason.failureReason
            
        case .internalError(let reason):
            return reason.failureReason
            
        case .storageError(let reason):
            return reason.failureReason
        }
    }
}

extension MyError.Network: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .api(let title, _, _):
            return title
            
        case .unauthorized:
            return "Unauthorized"
        }
    }
    
    var failureReason: String? {
        switch self {
        case .api(_, let subtitle, _):
            return subtitle
            
        case .unauthorized:
            return "Unauthorized"
        }
    }
}


extension MyError.Internal: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        default:
            return nil
        }
    }
    
    var failureReason: String? {
        switch self {
        default:
            return nil
        }
    }
}


extension MyError.Storage: LocalizedError {
    var errorDescription: String? {
        switch self {
        default:
            return nil
        }
    }
    
    var failureReason: String? {
        switch self {
        default:
            return nil
        }
    }
}
