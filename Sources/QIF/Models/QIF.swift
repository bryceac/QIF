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
    public var transactions: Set<QIFTransaction>
}

extension QIF {
    /**
     initialize QIF Value from string.
     - Returns: QIF value made from the string.
     - Throws: QIFTypeParsingError if type cannot be determined.
     */
    public init(_ text: String) throws {
        let type = try QIFType(text)
        
        /* separate out records in string based upon the details mentionedat the following URL: https://stuff.mit.edu/afs/sipb/project/gnucash/1.6.4/arch/sun4x_58/share/gnome/help/gnucash/C/intro.html */
        let transactionBlocks = text.components(separatedBy: "^")
        
        var transactions: [QIFTransaction] = []
        
        for block in transactionBlocks {
            guard let transaction = try? QIFTransaction(block) else { continue }
            
            transactions.append(transaction)
        }
        
        self.type = type
        self.transactions = Set(transactions)
    }
}

extension QIF: CustomStringConvertible {
    
    /**
    the string representation of the QIF data. The string utilizes Windows newline sematics.
     */
    public var description: String {
        var value = "!Type:\(type.rawValue)\r\n"
        
        for transaction in transactions {
            value += "\(transaction)\r\n\r\n"
        }
        return value
    }
}

extension QIF: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.type == rhs.type &&
        lhs.transactions == rhs.transactions
    }
}

extension QIF {
    /**
     load transaction from specified QIF file.
     - Returns: QIF model.
     */
    public static func load(from file: URL) throws -> QIF {
        let fileData = try Data(contentsOf: file)
        guard let text = String(data: fileData, encoding: .utf8) else {
            fatalError("Could not decode data.")
        }
        
        let qif = try QIF(text)
        
        return qif
    }
    
    /**
     save QIF data to a specified location.
     */
    public func save(to path: URL) throws {
        try "\(self)".write(to: path, atomically: true, encoding: .utf8)
    }
}
