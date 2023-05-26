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
    @Persisted var timestamp: Date = Date()
    @Persisted var total: Double = 0.00
    @Persisted var items: RealmSwift.List<SaleItemEntity>
    
    convenience init(timestamp: Date, total: Double) {
        self.init()
        self._id = _id
        self.timestamp = timestamp
        self.total = total
    }
}

class SaleItemEntity: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted(originProperty: "items") var sale: LinkingObjects<SaleEntity>
    @Persisted var name: String = ""
    @Persisted var qtyToPurchase: Int = 0
    @Persisted var price: Double = 0.00
    
    convenience init(name: String, qtyToPurchase: Int, price: Double) {
        self.init()
        self.name = name
        self.qtyToPurchase = qtyToPurchase
        self.price = price
    }
}
