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
            print("Error getting date for preview")
            return Date()
        }
        return someDateTime
    }
    
    
    //Sample Data For Previews, use yyyy-MM-dd HH:mm
    static let todaySale1: SaleEntity = SaleEntity(timestamp: Date(timeIntervalSinceNow: 0), total: 32.50)
    static let yesterdaySale1: SaleEntity = SaleEntity(timestamp: Date(timeIntervalSinceNow: -dayTimeInterval), total: 32.50)
    
}

let dayTimeInterval: Double = 86400

class SaleItemEntity: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted(originProperty: "items") var sale: LinkingObjects<SaleEntity>
    @Persisted var name: String = ""
    @Persisted var qtyToPurchase: Int = 0
    @Persisted var unitPrice: Double = 0.00
    
    convenience init(name: String, qtyToPurchase: Int, unitPrice: Double) {
        self.init()
        self.name = name
        self.qtyToPurchase = qtyToPurchase
        self.unitPrice = unitPrice
    }
    
    static let saleItem1: SaleItemEntity = SaleItemEntity(name: "Cheetos", qtyToPurchase: 2, unitPrice: 1.5)
    static let saleItem2: SaleItemEntity = SaleItemEntity(name: "Milk", qtyToPurchase: 1, unitPrice: 1.0)
}

struct SaleModel {
    let timeStamp: Date
    let total: Double
    
//    init(from: SaleEntity) {
//        
//    }
}
