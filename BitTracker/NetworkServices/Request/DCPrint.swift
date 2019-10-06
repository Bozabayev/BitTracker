//
//  DCPrint.swift
//  BitTracker
//
//  Created by Rauan on 10/6/19.
//  Copyright © 2019 Rauan. All rights reserved.
//

import Foundation
import UIKit


public func DCPrint(_ items: Any...,  separator: String = " ", terminator: String = "\n", _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    #if DEBUG
  
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let date = Date()
        let s = formatter.string(from: date)
        
        let stringItem = items.map {"\($0)"}.joined(separator: separator)
        Swift.print("\(s), \"\(function)\":\n\(stringItem)\n", terminator: terminator)
    
    #else
    // Do nothing
    #endif
}
