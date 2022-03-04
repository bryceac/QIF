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
