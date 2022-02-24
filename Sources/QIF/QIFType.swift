//
//  File.swift
//  
//
//  Created by Bryce Campbell on 2/24/22.
//

import Foundation

enum QIFType: String, CaseIterable {
    case cash = "Cash", bank = "Bank", creditCard = "CCard", liability = "Oth L", asset = "Oth A"
}

extension QIFType: LosslessStringConvertible {
    var description: String {
        return self.rawValue
    }
    
    init?(_ description: String) {
        guard let typeMatches = description.matching(regexPattern: "!Type:(.*)"), let firstMatch = typeMatches.first else { return nil }
        
        self.init(rawValue: firstMatch[1])
    }
    
}
