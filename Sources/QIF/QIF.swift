//
//  File.swift
//  
//
//  Created by Bryce Campbell on 2/24/22.
//

import Foundation

struct QIF {
    var type: QIFType
    var transactions: [QIFTransaction]
}

extension QIF: LosslessStringConvertible {
    var description: String {
        var value = "!Type:\(type.rawValue)\r\n"
        
        for transaction in transactions {
            value += """
            \(transaction)
            \n
            """
        }
        return value
    }
    
    init?(_ description: String) {
        guard let typeMatching = description.matching(regexPattern: "!Type:(.*)"), let firstMatch = typeMatching.first else { return nil }
        
        let typeString = firstMatch[1]
        
        guard let type = QIFType(rawValue: typeString) else { return nil }
        
        self.type = type
        
        var transactionBlocks = description.components(separatedBy: "^")
        
        transactionBlocks = transactionBlocks.indices.reduce(into: [], { initialValue, index in
            if index == 0 {
                let newString = transactionBlocks[index].components(separatedBy: "\n")
                
                initialValue.append(newString.dropFirst().joined(separator: "\n"))
            } else {
                initialValue.append(transactionBlocks[index])
            }
        })
        
        var transactions: [QIFTransaction] = []
        
        for block in transactionBlocks {
            guard let transaction = QIFTransaction(block) else { continue }
            
            print(transaction)
            
            transactions.append(transaction)
        }
        
        self.transactions = transactions
    }
}

extension QIF: Equatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.type == rhs.type &&
        lhs.transactions == rhs.transactions
    }
}
