//
//  Date+Ext.swift
//  InventoryX
//
//  Created by Ryan Smetana on 4/22/24.
//

import Foundation


extension Date {
    /// Generate a random date in the provided range.
    static func random(in range: ClosedRange<Date>) -> Date {
        let diff = range.upperBound.timeIntervalSinceReferenceDate - range.lowerBound.timeIntervalSinceReferenceDate
        let randomValue = diff * Double.random(in: 0...1) + range.lowerBound.timeIntervalSinceReferenceDate
        return Date(timeIntervalSinceReferenceDate: randomValue)
    }
}
