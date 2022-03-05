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
    /**
    initialize type of QIF file from string.
    - Returns: QIFType enumeration value.
    - Throws: QIFTypeParsingError if the format is not correct or section name is not valid.
    */
    public init(_ text: String) throws {
        guard let sectionMatches = text.matching(regexPattern: "!Type:(.*)") else {
            throw QIFTypeParsingError.incorrectFormat
        }
        
        guard let typeString = sectionMatches.compactMap({ $0.last }).first(where: { !(.none ~= QIFType(rawValue: $0)) }), let type = QIFType(rawValue: typeString) else {
            throw QIFTypeParsingError.noValidSections
        }
        
        self = type
    }
}
