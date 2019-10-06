//
//  String.swift
//  BitTracker
//
//  Created by Rauan on 10/6/19.
//  Copyright © 2019 Rauan. All rights reserved.
//

import Foundation


extension String {
    func getStringDateFromTimeStamp() -> String {
        
        let date = Date(timeIntervalSince1970: Double(self)!)
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "yyyy-MM-dd, HH:mm:ss"
        
        let dateString = dayFormatter.string(from: date as Date)
        return dateString
    }
}
