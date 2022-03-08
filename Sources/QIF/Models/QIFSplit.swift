//
//  File.swift
//  
//
//  Created by Bryce Campbell on 3/7/22.
//

import Foundation

public struct QIFSplit {
    public var category: String?
    public var memo: String = ""
    public var amount: Double = 0
}

extension QIFSplit: CustomStringConvertible {
    public var description: String {
        return """
        S\(category ?? "")
        E\(memo)
        $\(amount)
        """
    }
}

extension QIFSplit: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.category == rhs.category &&
        lhs.memo == rhs.memo &&
        lhs.amount == rhs.amount
    }
}

extension QIFSplit: Hashable {}
