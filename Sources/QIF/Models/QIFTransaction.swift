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

extension QIFTransaction: LosslessStringConvertible {
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
    
    public init?(_ description: String) {
        
        let text = description.starts(with: "!Type:") ? description.components(separatedBy: .newlines).dropFirst().joined(separator: "/r/n") : description
        
        guard let transactionString = text.matching(regexPattern: "(?:\\s*)?(?:D)?(.*)\\s*([T|U|C|N|P|M|A|L])?(.*)\\s*([T|U|C|N|P|M|A|L])?(.*)\\s*([T|U|C|N|P|M|A|L])?(.*)\\s*([T|U|C|N|P|M|A|L])?(.*)\\s*([T|U|C|N|P|M|A|L])?(.*)\\s*([T|U|C|N|P|M|A|L])?(.*)\\s*([T|U|C|N|P|M|A|L])?(.*)\\s*[^\\^]"), let firstMatch = transactionString.first else { return nil }
        
        var transactionValues: [String: String] = [:]
        
        transactionValues["date"] = firstMatch[1]
        
        for groupIndex in firstMatch.indices {
            
            guard groupIndex > 1 else { continue }
            
            if groupIndex.isMultiple(of: 2) {
                let key = firstMatch[groupIndex]
                let value = firstMatch[groupIndex+1]
                
                transactionValues[key] = value
            }
        }
        
        if let dateString = transactionValues["date"], let date = QIFTransaction.QIF_DATE_FORMATTER.date(from: dateString) {
            self.date = date
        } else {
            date = Date()
        }
        
        if let amountString = transactionValues["T"], let amount = QIFTransaction.TRANSACTION_AMOUNT_FORMAT.number(from: amountString) {
            self.amount = amount.doubleValue
        } else if let amountString = transactionValues["U"], let amount = QIFTransaction.TRANSACTION_AMOUNT_FORMAT.number(from: amountString) {
            self.amount = amount.doubleValue
        } else {
            amount = 0
        }
        
        if let checkNumber = transactionValues["N"] {
            self.checkNumber = Int(checkNumber)
        } else {
            checkNumber = nil
        }
        
        if let vendor = transactionValues["P"] {
            self.vendor = vendor
        } else {
            vendor = ""
        }
        
        if let address = transactionValues["A"] {
            self.address = address
        } else {
            address = ""
        }
        
        if let category = transactionValues["L"] {
            self.category = category
        } else {
            category = nil
        }
        
        if let memo = transactionValues["M"] {
            self.memo = memo
        } else {
            memo = ""
        }
        
        if let status = transactionValues["C"], !status.isEmpty {
            self.status = TransactionStatus(rawValue: status)
        } else {
            status = nil
        }
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
