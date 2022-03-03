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
        
    }
}
