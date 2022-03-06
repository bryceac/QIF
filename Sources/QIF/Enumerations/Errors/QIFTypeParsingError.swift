//
//  File.swift
//  
//
//  Created by Bryce Campbell on 3/3/22.
//

import Foundation

enum QIFTypeParsingError: LocalizedError {
    case incorrectFormat, invalidType
    
    var errorDescription: String? {
        var error = ""
        
        switch self {
        case .incorrectFormat: error = "The format presented in invalid. The type or section must be specified like in this format !Type:Account Type"
        case .invalidType: error = "Specified Type is invalid. The type can only be Cash, Bank, CCard, Oth L, or Oth A"
        }
        
        return error
    }
}
