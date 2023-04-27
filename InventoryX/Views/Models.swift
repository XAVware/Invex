//
//  Models.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/24/23.
//

import SwiftUI
import RealmSwift
import Realm

//Used to persist data to storage
class CategoryEntity: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var restockNumber: Int
    
    convenience init(name: String, restockNum: Int = 10) {
        self.init()
        self.name = name
        self.restockNumber = restockNum
    }
    
    
    //Sample Data For Previews
    static let foodCategory: CategoryEntity = CategoryEntity(name: "Food")
    static let drinkCategory: CategoryEntity = CategoryEntity(name: "Drinks")
    static let frozenCategory: CategoryEntity = CategoryEntity(name: "Frozen")
    static let categoryArray = [foodCategory, drinkCategory, frozenCategory]

}

//Used as temporary model
struct CategoryModel {
    let name: String
    var restockNumber: Int
}

class InventoryItemEntity: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String          = ""
    @Persisted var subtype: String       = ""
    @Persisted var category: ObjectId
    @Persisted var retailPrice: Double   = 0.00
    @Persisted var avgCostPer: Double    = 0.00
    @Persisted var onHandQty: Int        = 0
    
    convenience init(name: String, subtype: String, category: ObjectId, retailPrice: Double, avgCostPer: Double, onHandQty: Int) {
        self.init()
        self.name = name
        self.subtype = subtype
        self.category = category
        self.retailPrice = retailPrice
        self.avgCostPer = avgCostPer
        self.onHandQty = onHandQty
    }
    
    //Sample Data For Previews
    static let item1 = InventoryItemEntity(name: "Lays", subtype: "", category: CategoryEntity.foodCategory._id, retailPrice: 1.00, avgCostPer: 0.50, onHandQty: 10)
    static let item2 = InventoryItemEntity(name: "Skittles", subtype: "", category: CategoryEntity.foodCategory._id, retailPrice: 1.00, avgCostPer: 0.50, onHandQty: 10)
    static let item3 = InventoryItemEntity(name: "Starburst", subtype: "", category: CategoryEntity.foodCategory._id, retailPrice: 1.00, avgCostPer: 0.50, onHandQty: 10)
    static let item4 = InventoryItemEntity(name: "Water", subtype: "", category: CategoryEntity.drinkCategory._id, retailPrice: 1.00, avgCostPer: 0.50, onHandQty: 10)
    static let item5 = InventoryItemEntity(name: "Gatorade", subtype: "", category: CategoryEntity.drinkCategory._id, retailPrice: 1.00, avgCostPer: 0.50, onHandQty: 10)
    static let item6 = InventoryItemEntity(name: "Energy Drink", subtype: "", category: CategoryEntity.drinkCategory._id, retailPrice: 1.00, avgCostPer: 0.50, onHandQty: 10)
    static let item7 = InventoryItemEntity(name: "Ice Pop", subtype: "", category: CategoryEntity.frozenCategory._id, retailPrice: 1.00, avgCostPer: 0.50, onHandQty: 10)
    
    static let itemArray = [item1, item2, item3, item4, item5, item6, item7]
    
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

public extension EnvironmentValues {
    var isPreview: Bool {
#if DEBUG
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
#else
        return false
#endif
    }
}
