//
//  Double+Ext.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/24/24.
//

import Foundation

extension Double {
    func toCurrencyString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        let nsnum = NSNumber(floatLiteral: self)
        return formatter.string(from: nsnum) ?? "$$$"
    }
    
    func toPercentageString(includeSymbol: Bool = true) -> String {
        String(format: "%.2f", self * 100) + (includeSymbol ? "%" : "")
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .decimal
//        formatter.maximumFractionDigits = 2
//        formatter.minimumFractionDigits = 0
//        let wholePercent = self * 100
//        let rawPercentageString = formatter.string(from: NSNumber(value: wholePercent)) ?? ""
//        return String(format: "%.2f", rawPercentageString) + (includeSymbol ? "%" : "")
    }
}
