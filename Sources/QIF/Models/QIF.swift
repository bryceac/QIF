//
//  File.swift
//  
//
//  Created by Bryce Campbell on 2/24/22.
//

import Foundation

/// QIF represents a QIF document
public struct QIF {
    /// the type of transactions contain in the document
    public var type: QIFType
    public var transactions: [QIFTransaction]
}

extension QIF: LosslessStringConvertible {
    
    /**
    the string representation of the QIF data. The string utilizes Windows newline sematics.
     */
    public var description: String {
        var value = "!Type:\(type)\r\n"
        
        for transaction in transactions {
            value += "\(transaction)\r\n\r\n"
        }
        return value
    }
    
    /// attempt to initialize a QIF value from a given string.
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

extension QIF {
    public static load(from file: URL) throws -> QIF? {
        let fileData = try Data(contentsOf: file)
        guard let text = String(data: fileData, encoding: .utf8) else { return nil }
        
        guard let qif = QIF(text) else { return nil }
        
        return qif
    }
    
    public func save(to path: URL) throws {
        try "\(self)".write(to: path, atomically: true, encoding: .utf8)
    }
}
