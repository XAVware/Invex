//
//  Date+Ext.swift
//  InventoryX
//
//  Created by Ryan Smetana on 5/29/23.
//

import SwiftUI

extension Date {
    func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }
    
}
