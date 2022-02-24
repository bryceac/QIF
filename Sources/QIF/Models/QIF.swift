//
//  File.swift
//  
//
//  Created by Bryce Campbell on 2/24/22.
//

import Foundation

public struct QIF {
    public var type: QIFType
    public var transactions: [QIFTransaction]
}

extension QIF: LosslessStringConvertible {
    public var description: String {
        var value = "!Type:\(type.rawValue)\r\n"
        
        for transaction in transactions {
            value += "\(transaction)\r\n\r\n"
        }
        return value
    }
    
    public init?(_ description: String) {
        guard let type = QIFType(description) else { return nil }
        
        let transactionBlocks = description.components(separatedBy: "^")
        
        var transactions: [QIFTransaction] = []
        
        for block in transactionBlocks {
            guard let transaction = QIFTransaction(block) else { continue }
            
            print(transaction)
            
            transactions.append(transaction)
        }
        
        self.type = type
        self.transactions = transactions
    }
}

extension QIF: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.type == rhs.type &&
        lhs.transactions == rhs.transactions
    }
}
