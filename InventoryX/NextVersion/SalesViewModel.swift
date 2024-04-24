//
//  SalesViewModel.swift
//  InventoryX
//
//  Created by Ryan Smetana on 4/22/24.
//

import SwiftUI

class SalesViewModel: ObservableObject {
    @Published var salesData = [SaleEntity]()
    
    /// The total dollar amount of all sales in `saleData`
    var totalSalesCount: Int {
        salesData.count
    }
    
    /// Total sales from previous range
    @Published var lastTotalSales: Int = 0
    
    var salesCountByWeek: [(day: Date, salesCount: Int)] {
        let salesByWeek = salesGroupedByWeek(sales: salesData)
        return totalSalesPerDate(salesByDate: salesByWeek)
    }
    
    init() {
        
    }
    
    /// Loop through the current sales and figure out which week the sale belongs to. Group it with other sales that week.
    func salesGroupedByWeek(sales: [SaleEntity]) -> [Date: [SaleEntity]] {
        var salesByWeek: [Date: [SaleEntity]] = [:]
        
        let cal = Calendar.current
        for sale in sales {
            guard let startOfWeek = cal.date(from: cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: sale.timestamp)) else { continue }
            
            if salesByWeek[startOfWeek] != nil {
                salesByWeek[startOfWeek]!.append(sale)
            } else {
                salesByWeek[startOfWeek] = [sale]
            }
        }
        
        return salesByWeek
    }
    
    func totalSalesPerDate(salesByDate: [Date: [SaleEntity]]) -> [(day: Date, salesCount: Int)] {
        var salesCount: [(day: Date, salesCount: Int)] = []
        
        for (date, sales) in salesByDate {
            let countForDate = sales.count
            salesCount.append((day: date, salesCount: countForDate))
        }
        
        return salesCount
    }
}
