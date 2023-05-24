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
    
}

class SaleItemEntity: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String = ""
    @Persisted var subtype: String = ""
    @Persisted var qtyToPurchase: Int = 0
    @Persisted var price: Double = 0.00
}

// OLD
class SaleItem: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var qtyToPurchase: Int = 0
    @objc dynamic var price: Double = 0.00
}

class Sale: Object {
    @objc dynamic var timestamp: Date = Date()
    var items = RealmSwift.List<SaleItem>()
    @objc dynamic var total: Double = 0.00
}
