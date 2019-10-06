//
//  Currency.swift
//  BitTracker
//
//  Created by Rauan on 10/4/19.
//  Copyright © 2019 Rauan. All rights reserved.
//

import Foundation
import SwiftyJSON



class Currency : Codable {
    var code : String?
    var rate : String?
    var rate_float : Double?
    var description : String?
    
    enum CodingKeys : String, CodingKey {
        case code,rate,rate_float,description
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decode(String.self, forKey: .code)
        self.rate = try container.decode(String.self, forKey: .rate)
        self.rate_float = try container.decode(Double.self, forKey: .rate_float)
        self.description = try container.decode(String.self, forKey: .description)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(rate, forKey: .rate)
        try container.encode(rate_float, forKey: .rate_float)
        try container.encode(description, forKey: .description)
    }
    
}
