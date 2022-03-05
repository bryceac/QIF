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
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MM/dd/yyyy"
        
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
    
    /**
     initialize transaction from string input.
     - Returns: QIFTransaction value
     - Throws: QIFTransactionParsingError if date is not in the correct format or does not exist, no vendor or payee is specified, or either no amount is specified or the amount specified is not a numerical value.
     */
    public init(_ text: String) throws {
        var transactionValues: [String:String] = [:]
        
        let lines = text.components(separatedBy: .newlines)
        
        for line in lines {
            switch line {
                case let l where l.starts(with: "D"):
                    let date = String(l.dropFirst())
                    transactionValues["date"] = date
                case let l where l.starts(with: "T") || l.starts(with: "U"):
                    let amount = String(l.dropFirst())
                    transactionValues["amount"] = amount
                case let l where l.starts(with: "N"):
                    let checkNumber = String(l.dropFirst())
                    transactionValues["checkNumber"] = checkNumber
                case let l where l.starts(with: "P"):
                    let vendor = String(l.dropFirst())
                    transactionValues["vendor"] = vendor
                case let l where l.starts(with: "A"):
                    let address = String(l.dropFirst())
                    transactionValues["address"] = address
                case let l where l.starts(with: "L"):
                    let category = String(l.dropFirst())
                    transactionValues["category"] = category
                case let l where l.starts(with: "M"):
                    let memo = String(l.dropFirst())
                    transactionValues["memo"] = memo
                case let l where l.starts(with: "C"):
                    let status = String(l.dropFirst())
                    transactionValues["status"] = status
                default: ()
            }
        }
        
        guard let date = transactionValues["date"], let transactionDate = QIFTransaction.QIF_DATE_FORMATTER.date(from: date) else {
            throw .none ~= transactionValues["date"] ? QIFTransactionParsingError.noDateFound : QIFTransactionParsingError.wrongDateFormat
        }
        
        guard let amount = transactionValues["amount"], let transactionAmount = QIFTransaction.TRANSACTION_AMOUNT_FORMAT.number(from: amount) else {
            throw .none ~= transactionValues["amount"] ? QIFTransactionParsingError.fieldNotFound(field: "amount") : QIFTransactionParsingError.valueNotNumerical(value: transactionValues["amount"]!, field: "amount")
        }
        
        self.date = transactionDate
        self.amount = transactionAmount.doubleValue
        
        if let checkNumber = transactionValues["checkNumber"], let transactionCheckNumber = Int(checkNumber) {
            self.checkNumber = transactionCheckNumber
        } else {
            checkNumber = nil
        }
        
        guard let vendor = transactionValues["vendor"] else {
            throw QIFTransactionParsingError.noVendor
        }
        
        self.vendor = vendor
        
        if let address = transactionValues["address"] {
            self.address = address
        } else {
            address = vendor
        }
        
        category = transactionValues["category"]
        
        if let memo = transactionValues["memo"] {
            self.memo = memo
        } else {
            memo = ""
        }
        
        if let status = transactionValues["status"] {
            self.status = TransactionStatus(rawValue: status)
        } else {
            status = nil
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
        return lhs.date == rhs.date &&
        lhs.checkNumber == rhs.checkNumber &&
        lhs.vendor == rhs.vendor &&
        lhs.address == rhs.address &&
        lhs.amount == rhs.amount &&
        lhs.category == rhs.category &&
        lhs.memo == rhs.memo &&
        lhs.status == rhs.status
    }
}

extension QIFTransaction: Hashable {}
