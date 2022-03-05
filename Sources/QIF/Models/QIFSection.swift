//
//  File.swift
//  
//
//  Created by Bryce Campbell on 3/5/22.
//

import Foundation

struct QIFSection {
    let type: QIFType
    
    var transactions: Set<QIFTransaction>
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
