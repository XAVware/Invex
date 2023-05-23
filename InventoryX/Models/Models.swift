//
//  Models.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/24/23.
//

import SwiftUI
import RealmSwift
import Realm

class InventoryItemEntity: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted(originProperty: "items") var category: LinkingObjects<CategoryEntity>
    @Persisted var subtypes: RealmSwift.List<ChildInventoryItemEntity>
    
    @Persisted var name: String
    @Persisted var retailPrice: Double
    @Persisted var avgCostPer: Double
    @Persisted var onHandQty: Int
    
    convenience init(name: String, retailPrice: Double, avgCostPer: Double, onHandQty: Int) {
        self.init()
        self.name = name
        self.retailPrice = retailPrice
        self.avgCostPer = avgCostPer
        self.onHandQty = onHandQty
    }
    
    //Sample Data For Previews
    static let item1 = InventoryItemEntity(name: "Lays", retailPrice: 1.00, avgCostPer: 0.50, onHandQty: 10)
    static let item2 = InventoryItemEntity(name: "Skittles", retailPrice: 1.50, avgCostPer: 0.50, onHandQty: 15)
    static let item3 = InventoryItemEntity(name: "Starburst", retailPrice: 1.00, avgCostPer: 0.50, onHandQty: 10)
    static let item4 = InventoryItemEntity(name: "Water", retailPrice: 1.00, avgCostPer: 0.50, onHandQty: 4)
    static let item5 = InventoryItemEntity(name: "Gatorade", retailPrice: 1.00, avgCostPer: 0.50, onHandQty: 10)
    static let item6 = InventoryItemEntity(name: "Energy Drink", retailPrice: 3.00, avgCostPer: 0.50, onHandQty: 7)
    static let item7 = InventoryItemEntity(name: "Ice Pop", retailPrice: 0.50, avgCostPer: 0.50, onHandQty: 13)

    static let foodArray = [item1, item2, item3]
    static let drinkArray = [item4, item5, item6]
    static let frozenArray = [item7]
    
}

class ChildInventoryItemEntity: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted(originProperty: "subtypes") var itemParent: LinkingObjects<InventoryItemEntity>
    @Persisted var name: String
    @Persisted var retailPrice: Double
    @Persisted var avgCostPer: Double
    @Persisted var onHandQty: Int
    
    convenience init(name: String, retailPrice: Double, avgCostPer: Double, onHandQty: Int) {
        self.init()
        self.name = name
        self.retailPrice = retailPrice
        self.avgCostPer = avgCostPer
        self.onHandQty = onHandQty
    }
}

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

enum UserRole: String, PersistableEnum {
    case admin
    case manager
    case employee
}

class UserEntity: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var profileName: String = ""
    @Persisted var email: String?
    @Persisted var passcode: String?
    @Persisted var role: UserRole = UserRole.employee
    
    convenience init(profileName: String, email: String?, passcode: String?, role: UserRole) {
        self.init()
        self.profileName = profileName
        self.email = email
        self.role = role
    }
}
