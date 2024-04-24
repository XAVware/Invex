//
//  Sale.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 5/23/23.
//

import SwiftUI
import RealmSwift


class SaleEntity: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var timestamp: Date
    @Persisted var total: Double = 0.00
    @Persisted var cashierName: String
    @Persisted var items: RealmSwift.List<SaleItemEntity>
    
    convenience init(timestamp: Date, total: Double) {
        self.init()
        self._id = _id
        self.timestamp = timestamp
        self.total = total
    }
    
    private func getDate(from dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        guard let someDateTime = formatter.date(from: "2016/10/08 22:31") else {
//            LogService(String(describing: self)).error("Error getting date for preview")
            return Date()
        }
        return someDateTime
    }
    
    
    
}

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

class SaleItemEntity: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted(originProperty: "items") var sale: LinkingObjects<SaleEntity>
    @Persisted var name: String = ""
    @Persisted var attribute: String = ""
    //    @Persisted var qtyToPurchase: Int = 0
    @Persisted var retailPrice: Double = 0.00
//    @Persisted var unitPrice: Double = 0.00
    
    convenience init(name: String, attribute: String, retailPrice: Double, unitPrice: Double) {
        self.init()
        self.name = name
        //        self.qtyToPurchase = qtyToPurchase
//        self.unitPrice = unitPrice
    }
    
    convenience init(item: ItemEntity) {
        self.init()
        self.name = item.name
        self.attribute = item.attribute
        self.retailPrice = item.retailPrice
        
    }
    
    static let saleItem1: SaleItemEntity = SaleItemEntity(name: "Cheetos", attribute: "sample", retailPrice: 1.0, unitPrice: 1.5)
    static let saleItem2: SaleItemEntity = SaleItemEntity(name: "Milk", attribute: "sample", retailPrice: 1.0, unitPrice: 1.0)
}

