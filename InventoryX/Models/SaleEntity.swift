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
            return Date()
        }
        return someDateTime
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
    
}
