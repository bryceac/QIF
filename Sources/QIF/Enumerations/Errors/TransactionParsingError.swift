//
//  File.swift
//  
//
//  Created by Bryce Campbell on 3/3/22.
//

import Foundation

enum TransactionParsingError: LocalizedError {
    case incorrectFormat
    
    var errorDescription: String? {
        var error = ""
        
        switch self {
            case .incorrectFormat: error = "Transaction is not in the expected format."
        }
        
        return error
    }
}
