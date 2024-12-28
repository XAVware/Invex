//
//  Double+Ext.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/24/24.
//

import Foundation

extension Double {
    func rounded(to places: Int) -> Double {
        let multiplier = pow(10.0, Double(places))
        return (self * multiplier).rounded() / multiplier
    }
    
    func toCurrencyString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        let roundedValue = self.rounded(to: 2)
        let nsnum = NSNumber(floatLiteral: roundedValue)
        return formatter.string(from: nsnum) ?? "$$$"
    }
    
    func toPercentageString(includeSymbol: Bool = true) -> String {
        let roundedValue = (self * 100).rounded(to: 2)
        return "\(roundedValue)" + (includeSymbol ? "%" : "")
    }
}
