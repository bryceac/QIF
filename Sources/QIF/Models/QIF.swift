//
//  File.swift
//  
//
//  Created by Bryce Campbell on 2/24/22.
//

import Foundation

/// QIF represents a QIF document
public struct QIF {
    public var sections: [String: QIFSection]
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
        
        var sections: [String: QIFSection] = [:]
        
        var latestSection: QIFSection? = nil
        
        for block in transactionBlocks {
            if let section = try? QIFSection(block), !sections.keys.contains(section.type.rawValue) {
                sections[section.type.rawValue] = section
                latestSection = sections[section.type.rawValue]
            } else if let transaction = try? QIFTransaction(block), let latestSection = latestSection {
                sections[latestSection.type.rawValue]?.transactions.insert(transaction)
            }
        }
        self.sections = sections
    }
}

extension QIF: CustomStringConvertible {
    
    /**
    the string representation of the QIF data. The string utilizes Windows newline sematics.
     */
    public var description: String {
        return sections.values.reduce(into: "") { string, section in
            string += "\(section)"
        }
    }
}

extension QIF: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.sections == rhs.sections
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
