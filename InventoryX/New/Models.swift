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
    @Persisted var itemType: String      = ""
    @Persisted var retailPrice: Double   = 0.00
    @Persisted var avgCostPer: Double    = 0.00
    @Persisted var onHandQty: Int        = 0
}

class SaleEntity: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var timestamp: Date = Date()
    @Persisted var total: Double = 0.00
//    @Persisted var items: List<SaleItemEntity>

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

class User: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var profileName: String = ""
    @Persisted var email: String?
    @Persisted var role: UserRole = UserRole.employee
    
    convenience init(profileName: String, email: String?, role: UserRole) {
        self.init()
        self.profileName = profileName
        self.email = email
        self.role = role
    }
}
