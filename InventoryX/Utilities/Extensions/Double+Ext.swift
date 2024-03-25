//
//  Double+Ext.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/24/24.
//

import Foundation

extension Double {
    func formatAsCurrencyString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        
        let nsnum = NSNumber(floatLiteral: self)
        return formatter.string(from: nsnum) ?? "$$$"
    }
}
