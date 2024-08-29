//
//  SaleData.swift
//  InventoryX
//
//  Created by Ryan Smetana on 5/11/24.
//

import Foundation

extension SaleEntity {
    static let dayTimeInterval: Double = 86400
    //Sample Data For Previews, use yyyy-MM-dd HH:mm
    static let todaySale1: SaleEntity = SaleEntity(timestamp: Date(timeIntervalSinceNow: 0), total: 32.50)
    static let yesterdaySale1: SaleEntity = SaleEntity(timestamp: Date(timeIntervalSinceNow: -dayTimeInterval), total: 32.50)
    
    /// Create 300 sales with timestamps over the past 3 months
    static func threeMonthsExamples() -> [SaleEntity] {
        let threeMonthsAgo = Calendar.current.date(byAdding: .month, value: -3, to: Date())!
        
        let exampleSales: [SaleEntity] = (1...300).map { _ in
            let randomItem = ItemEntity.drinkArray.randomElement()!
//            let randomQuantity = Int.random(in: 1...42)
            let randomDate = Date.random(in: threeMonthsAgo...Date())
            return SaleEntity(timestamp: randomDate, total: randomItem.retailPrice)
        }
        
        return exampleSales.sorted { $0.timestamp < $1.timestamp }
    }
}


extension SaleItemEntity {
    static let saleItem1: SaleItemEntity = SaleItemEntity(item: ItemEntity.item1)
    static let saleItem2: SaleItemEntity = SaleItemEntity(item: ItemEntity.item2)
}
