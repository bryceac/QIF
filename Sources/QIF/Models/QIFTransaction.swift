//
//  File.swift
//  
//
//  Created by Bryce Campbell on 2/24/22.
//

import Foundation

/// QIFTransaction represents a non investment transaction in a QIF file.
public struct QIFTransaction {
    public var date: Date
    public var checkNumber: Int?
    public var vendor: String
    public var address: String
    public var amount: Double
    public var category: String?
    public var memo: String
    public var status: TransactionStatus?
    
    public static let QIF_DATE_FORMATTER: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        return formatter
    }()
    
    public static let TRANSACTION_AMOUNT_FORMAT: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        
        return formatter
    }()
}

extension QIFTransaction {
    init(_ text: String) throws {
        let transactionValues: [String:String] = [:]
        
        let lines = text.components(separatedBy: .newlines)
        
        for line in lines {
            switch line {
                case let l where l.starts(with: "D"):
                let date = String(l.dropFirst())
                    print(date)
                case let l where l.starts(with: "T") || l.starts(with: "U"):
                    let amount = String(l.dropFirst())
                    print(amount)
                case let l where l.starts(with: "N"):
                    let checkNumber = String(l.dropFirst())
                    print(checkNumber)
                case let l where l.starts(with: "P"):
                    let vendor = String(l.dropFirst())
                    print(vendor)
                case let l where l.starts(with: "A"):
                    let address = String(l.dropFirst())
                    print(address)
                case let l where l.starts(with: "L"):
                    let category = String(l.dropFirst())
                    print(category)
                case let l where l.starts(with: "M"):
                    let memo = String(l.dropFirst())
                    print(memo)
                case let l where l.starts(with: "C"):
                    let status = String(l.dropFirst())
                    print(status)
                default: ()
            }
        }
    }
}

extension QIFTransaction: CustomStringConvertible {
    public var description: String {
        
        var statusValue = ""
        
        switch status {
        case let .some(status): statusValue = status.rawValue
        default: ()
        }
        
        return """
        D\(QIFTransaction.QIF_DATE_FORMATTER.string(from: date))
        T\(amount)
        C\(statusValue)
        N\(checkNumber ?? 0)
        P\(vendor)
        M\(memo)
        A\(address)
        L\(category ?? "")
        ^
        """
    }
}

extension QIFTransaction: Equatable {
   public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.checkNumber == rhs.checkNumber &&
        lhs.vendor == rhs.vendor &&
        lhs.address == rhs.address &&
        lhs.amount == rhs.amount &&
        lhs.category == rhs.category &&
        lhs.memo == rhs.memo &&
        lhs.status == rhs.status
    }
}
