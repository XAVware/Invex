//
//  SaleItemEntity.swift
//  InventoryX
//
//  Created by Ryan Smetana on 8/28/24.
//

import SwiftUI
import RealmSwift

class SaleItemEntity: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted(originProperty: "items") var sale: LinkingObjects<SaleEntity>
    @Persisted var name: String = ""
    @Persisted var attribute: String = ""
//    @Persisted var qtyToPurchase: Int = 0
    @Persisted var retailPrice: Double = 0.00
//    @Persisted var unitPrice: Double = 0.00
    
    /// Initialize a SaleItemEntity based on an ItemEntity
    /// Used while finalizeing a sale.
    convenience init(item: ItemEntity) {
        self.init()
        self.name = item.name
        self.attribute = item.attribute
        self.retailPrice = item.retailPrice
    }
}
