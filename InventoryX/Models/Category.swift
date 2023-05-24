//
//  Category.swift
//  InventoryX
//
//  Created by Ryan Smetana on 5/22/23.
//

import SwiftUI
import RealmSwift

struct CategoryModel {
    var _id: ObjectId?
    var name: String?
    var restockNumber: Int?
}

class CategoryEntity: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var restockNumber: Int
    @Persisted var items: RealmSwift.List<InventoryItemEntity>
    
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
