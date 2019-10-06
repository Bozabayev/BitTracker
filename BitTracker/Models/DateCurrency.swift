//
//  DateCurrency.swift
//  BitTracker
//
//  Created by Rauan on 10/5/19.
//  Copyright © 2019 Rauan. All rights reserved.
//

import Foundation
import SwiftyJSON



class DateCurrency : Codable {
    
    var bpi : [String : Double]? = [:]
    
    enum CodingKeys : String, CodingKey {
        case bpi
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.bpi = try container.decode([String : Double].self, forKey: .bpi)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(bpi, forKey: .bpi)
    }
}

extension String {
    func toDate(regex: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = regex
        dateFormatter.calendar = Calendar(identifier: .iso8601)
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC") //Current time zone
        return dateFormatter.date(from: self)
    }
}
