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
    @Persisted var defMarkup: Double
    
    convenience init(name: String, restockNum: Int = 10) {
        self.init()
        self.name = name
        self.restockNumber = restockNum
    }
    
    
}


// If data has changed drastically and preview data needs to be updated, uncomment the block containing the deleteAll function, open preview, then recomment the function out.
extension DepartmentEntity {
    static let foodCategory: DepartmentEntity = DepartmentEntity(name: "Food", restockNum: 10)
    static let drinkCategory: DepartmentEntity = DepartmentEntity(name: "Drinks", restockNum: 10)
    static let frozenCategory: DepartmentEntity = DepartmentEntity(name: "Frozen", restockNum: 10)
    static let categoryArray = [foodCategory, drinkCategory, frozenCategory]
    static let company: CompanyEntity = CompanyEntity(name: "Preview Co.", taxRate: 0.06)
    
    static var previewRealm: Realm {
        var realm: Realm
        let identifier = "previewRealm"
        let config = Realm.Configuration(inMemoryIdentifier: identifier)
        do {
            realm = try Realm(configuration: config)
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
                    realm.add(company)
                    foodCategory.items.append(objectsIn: ItemEntity.foodArray)
                    drinkCategory.items.append(objectsIn: ItemEntity.drinkArray)
                    frozenCategory.items.append(objectsIn: ItemEntity.frozenArray)
                }
                return realm
            }
        } catch {
            fatalError("Can't bootstrap item data: \(error.localizedDescription)")
        }
    }
}
