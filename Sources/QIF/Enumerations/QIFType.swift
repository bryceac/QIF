//
//  File.swift
//  
//
//  Created by Bryce Campbell on 2/24/22.
//

import Foundation

public enum QIFType: String, CaseIterable {
    case cash = "Cash", bank = "Bank", creditCard = "CCard", liability = "Oth L", asset = "Oth A"
}

extension QIFType {
    init(_ text: String) throws {
        guard let typeMatches = text.matching(regexPattern: "!Type:(.*)"), let firstMatch = typeMatches.first else {
            throw QIFTypeParsingError.incorrectFormat
        }
                
        guard let type = QIFType(rawValue: firstMatch[1]) else {
            throw QIFTypeParsingError.invalidType
        }
        
        self = type
    }
}
