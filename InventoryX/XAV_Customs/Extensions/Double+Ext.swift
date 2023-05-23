//
//  Doubl+Ext.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 5/23/23.
//

import Foundation

extension Double {
    func formatToCurrencyString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        
        let nsnum = NSNumber(floatLiteral: self)
        return formatter.string(from: nsnum) ?? "$$$"
    }
}
