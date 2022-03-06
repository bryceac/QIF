//
//  File.swift
//  
//
//  Created by Bryce Campbell on 3/5/22.
//

import Foundation

public struct QIFSection {
    public let type: QIFType
    
    public var transactions: Set<QIFTransaction>
    
    public init(type: QIFType, transactions: Set<QIFTransaction>) {
        self.type = type
        self.transactions = transactions
    }
}

extension QIFSection {
    init(_ text: String) throws {
        type = try QIFType(text)
        
        if let transaction = try? QIFTransaction(text) {
            transactions = Set([transaction])
        } else {
            transactions = Set<QIFTransaction>()
        }
    }
}

extension QIFSection: CustomStringConvertible {
    public var description: String {
        var value = "!Type:\(type.rawValue)\n"
        
        for transaction in transactions {
            value += "\(transaction)\n\n"
        }
        
        return value
    }
}

extension QIFSection: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.type == rhs.type && lhs.transactions == rhs.transactions
    }
}
