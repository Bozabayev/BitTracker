//
//  Transaction.swift
//  BitTracker
//
//  Created by Rauan on 10/6/19.
//  Copyright © 2019 Rauan. All rights reserved.
//

import Foundation



class Transaction: Codable {
    var date : String?
    var tid : Int?
    var price : String?
    var type : Int?
    var amount : String?
    
    enum CodingKeys : String, CodingKey {
        case date, tid, price, type, amount
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try container.decode(String.self, forKey: .date)
        self.tid = try container.decode(Int.self, forKey: .tid)
        self.price = try container.decode(String.self, forKey: .price)
        self.type = try container.decode(Int.self, forKey: .type)
        self.amount = try container.decode(String.self, forKey: .amount)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
         try container.encode(tid, forKey: .tid)
         try container.encode(type, forKey: .type)
         try container.encode(amount, forKey: .amount)
         try container.encode(price, forKey: .price)
    }
    
}
