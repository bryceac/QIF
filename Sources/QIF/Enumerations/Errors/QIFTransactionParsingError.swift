//
//  File.swift
//  
//
//  Created by Bryce Campbell on 3/4/22.
//

import Foundation

enum QIFTransactionParsingError: LocalizedError {
    case noDateFound, wrongDateFormat, valueNotNumerical(value: String, field: String)
    
    var errorDescription: String? {
        var error = ""
        
        switch self {
        case .noDateFound: error = "Date could not be found"
        case .wrongDateFormat: error = "Date must be in MM/DD/YYYY format"
        case .valueNotNumerical(let value, let field): error = "\(value) is an invalid value for \(field)"
        }
        
        return error
    }
}
