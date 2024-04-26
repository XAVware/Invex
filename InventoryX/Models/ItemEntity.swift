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
    
    var formattedPrice: String {
        return self.retailPrice.formatAsCurrencyString()
    }
    
    var formattedQty: String {
        return String(describing: self.onHandQty)
    }
    
    var formattedUnitCost: String {
        return self.unitCost.formatAsCurrencyString()
    }
    
    var showWarning: Bool {
        guard let dept = self.department.first else { return true }
        return self.onHandQty < dept.restockNumber
    }
    
    var restockWarning: String {
        guard let dept = department.first else { return "" }
        return onHandQty < dept.restockNumber ? "⚠️" : ""
    }
    
    var departmentName: String {
        return department.first?.name ?? ""
    }
    
}




extension ItemEntity {
    static let item1 = ItemEntity(name: "Layszz",       attribute: "Small", retailPrice: 1.00, avgCostPer: 0.50, onHandQty: 10)
    static let item2 = ItemEntity(name: "Skittles",     attribute: "Original", retailPrice: 1.50, avgCostPer: 0.50, onHandQty: 15)
    static let item3 = ItemEntity(name: "Starburst",    attribute: "", retailPrice: 1.00, avgCostPer: 0.50, onHandQty: 10)
    static let item4 = ItemEntity(name: "Water",        attribute: "Large", retailPrice: 1.00, avgCostPer: 0.50, onHandQty: 4)
    static let item5 = ItemEntity(name: "Gatorade",     attribute: "Blue", retailPrice: 1.00, avgCostPer: 0.50, onHandQty: 10)
    static let item6 = ItemEntity(name: "Energy Drink", attribute: "Sugar Free", retailPrice: 3.00, avgCostPer: 0.50, onHandQty: 7)
    static let item7 = ItemEntity(name: "Ice Pop",      attribute: "Rainbow", retailPrice: 0.50, avgCostPer: 0.50, onHandQty: 13)
    
    static let foodArray = [item1, item2, item3]
    static let frozenArray = [item7]
    
    
    // Additional Drinks
    static let drinkArray = [
        ItemEntity(name: "Water", attribute: "Cold", retailPrice: 1.0, avgCostPer: 0.25, onHandQty: 150),
        ItemEntity(name: "Iced Tea", attribute: "Cold", retailPrice: 1.5, avgCostPer: 0.45, onHandQty: 80),
        ItemEntity(name: "Coffee", attribute: "Hot", retailPrice: 2.0, avgCostPer: 0.5, onHandQty: 90),
        ItemEntity(name: "Smoothie", attribute: "Cold", retailPrice: 3.5, avgCostPer: 1.0, onHandQty: 60),
        ItemEntity(name: "Energy Drink", attribute: "Cold", retailPrice: 2.0, avgCostPer: 0.9, onHandQty: 85),
        ItemEntity(name: "Beer", attribute: "Cold", retailPrice: 4.0, avgCostPer: 1.5, onHandQty: 100),
        ItemEntity(name: "Soda", attribute: "Cold", retailPrice: 1.5, avgCostPer: 0.4, onHandQty: 120),
        ItemEntity(name: "Milkshake", attribute: "Cold", retailPrice: 3.0, avgCostPer: 1.2, onHandQty: 50),
        ItemEntity(name: "Hot Chocolate", attribute: "Hot", retailPrice: 2.5, avgCostPer: 0.8, onHandQty: 70),
        ItemEntity(name: "Fruit Juice", attribute: "Cold", retailPrice: 2.0, avgCostPer: 0.6, onHandQty: 90)
    ]

    static let snackArray = [
        ItemEntity(name: "Chips", attribute: "Packaged", retailPrice: 1.0, avgCostPer: 0.4, onHandQty: 100),
        ItemEntity(name: "Nachos", attribute: "Hot", retailPrice: 3.5, avgCostPer: 1.0, onHandQty: 50),
        ItemEntity(name: "Pretzel", attribute: "Hot", retailPrice: 2.0, avgCostPer: 0.5, onHandQty: 80),
        ItemEntity(name: "Candy", attribute: "Sweet", retailPrice: 1.5, avgCostPer: 0.3, onHandQty: 150),
        ItemEntity(name: "Sandwich", attribute: "Cold", retailPrice: 4.0, avgCostPer: 2.0, onHandQty: 60),
        ItemEntity(name: "Cookies", attribute: "Packaged", retailPrice: 2.0, avgCostPer: 0.7, onHandQty: 100),
        ItemEntity(name: "Burger", attribute: "Hot", retailPrice: 5.0, avgCostPer: 2.5, onHandQty: 40),
        ItemEntity(name: "Pizza Slice", attribute: "Hot", retailPrice: 3.0, avgCostPer: 1.1, onHandQty: 75),
        ItemEntity(name: "Ice Cream", attribute: "Cold", retailPrice: 2.5, avgCostPer: 0.9, onHandQty: 65),
        ItemEntity(name: "Muffin", attribute: "Packaged", retailPrice: 2.5, avgCostPer: 0.8, onHandQty: 80)
    ]

   

}
