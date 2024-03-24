//
//  Department.swift
//  InventoryX
//
//  Created by Ryan Smetana on 5/22/23.
//

import SwiftUI
import RealmSwift

class DepartmentEntity: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var restockNumber: Int
    @Persisted var items: RealmSwift.List<ItemEntity>
    
    convenience init(name: String, restockNum: Int = 10) {
        self.init()
        self.name = name
        self.restockNumber = restockNum
    }
    
    
}

extension DepartmentEntity {
    static let foodCategory: DepartmentEntity = DepartmentEntity(name: "Food", restockNum: 10)
    static let drinkCategory: DepartmentEntity = DepartmentEntity(name: "Drinks", restockNum: 10)
    static let frozenCategory: DepartmentEntity = DepartmentEntity(name: "Frozen", restockNum: 10)
    static let categoryArray = [foodCategory, drinkCategory, frozenCategory]
    
    static var previewRealm: Realm {
        var realm: Realm
        let identifier = "previewRealm"
        let config = Realm.Configuration(inMemoryIdentifier: identifier)
        do {
            realm = try Realm(configuration: config)
            // Check to see whether the in-memory realm already contains a Person.
            // If it does, we'll just return the existing realm.
            // If it doesn't, we'll add a Person append the Dogs.
            let realmObjects = realm.objects(DepartmentEntity.self)
            if realmObjects.count != 0 {
//                let realm = try Realm()
//                try realm.write {
//                    realm.deleteAll()
//                }
                return realm
            } else {
                try realm.write {
                    realm.add(foodCategory)
                    realm.add(drinkCategory)
                    realm.add(frozenCategory)
                    
                    foodCategory.items.append(objectsIn: ItemEntity.foodArray)
                    drinkCategory.items.append(objectsIn: ItemEntity.drinkArray)
                    frozenCategory.items.append(objectsIn: ItemEntity.frozenArray)
                }
                return realm
            }
        } catch let error {
            fatalError("Can't bootstrap item data: \(error.localizedDescription)")
        }
    }
}

//struct CategoryModel {
//    var _id: ObjectId?
//    var name: String?
//    var restockNumber: Int?
//}
