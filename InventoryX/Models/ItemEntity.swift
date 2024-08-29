//
//  InventoryItem.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 5/23/23.
//

import SwiftUI
import RealmSwift

class ItemEntity: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted(originProperty: "items") var department: LinkingObjects<DepartmentEntity>
    
    @Persisted var name: String
    @Persisted var attribute: String
    @Persisted var retailPrice: Double
    @Persisted var unitCost: Double
    @Persisted var onHandQty: Int
    
    convenience init(name: String, attribute: String, retailPrice: Double, avgCostPer: Double, onHandQty: Int = 0) {
        self.init()
        self.name = name
        self.attribute = attribute
        self.retailPrice = retailPrice
        self.unitCost = avgCostPer
        self.onHandQty = onHandQty
    }
    
    var formattedPrice: String { retailPrice.formatAsCurrencyString() }
    var formattedQty: String { String(describing: onHandQty) }
    var formattedUnitCost: String { unitCost.formatAsCurrencyString() }
    var departmentName: String { department.first?.name ?? "" }
    
    var showWarning: Bool {
        guard let dept = self.department.first else { return true }
        return onHandQty < dept.restockNumber
    }
    
    var restockWarning: String {
        guard let dept = department.first else { return "" }
        return onHandQty < dept.restockNumber ? "⚠️" : ""
    }
}
