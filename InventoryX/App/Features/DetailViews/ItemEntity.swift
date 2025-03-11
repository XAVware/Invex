//
//  InventoryItem.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 5/23/23.
//

import SwiftUI
import RealmSwift

class ItemEntity: Object, ObjectKeyIdentifiable, Identifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted(originProperty: "items") var department: LinkingObjects<DepartmentEntity>
    @Persisted var name: String
    @Persisted var attribute: String
    @Persisted var retailPrice: Double
    @Persisted var unitCost: Double
    @Persisted var onHandQty: Int
    
    convenience init(name: String, attribute: String, retailPrice: Double, avgCostPer: Double, onHandQty: Int = 0) {
        self.init()
        self._id = ObjectId.generate()
        self.name = name
        self.attribute = attribute
        self.retailPrice = retailPrice
        self.unitCost = avgCostPer
        self.onHandQty = onHandQty
    }
    
    var formattedPrice: String { retailPrice.toCurrencyString() }
    var showWarning: Bool {
        guard let dept = self.department.first else { return true }
        return onHandQty < dept.restockNumber
    }
}
