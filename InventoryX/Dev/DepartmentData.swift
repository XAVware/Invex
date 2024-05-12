//
//  DepartmentData.swift
//  InventoryX
//
//  Created by Ryan Smetana on 5/11/24.
//

import Foundation
import RealmSwift



// If data has changed drastically and preview data needs to be updated, uncomment the block containing the deleteAll function, open preview, then recomment the function out.
extension DepartmentEntity {
    static let company: CompanyEntity = CompanyEntity(name: "Preview Co.", taxRate: 0.06)
    
    static let foodCategory: DepartmentEntity = DepartmentEntity(name: "Food", restockNum: 10, defMarkup: 7)
    static let foodItems: [ItemEntity] = ItemEntity.foodArray
    
    static let drinkCategory: DepartmentEntity = DepartmentEntity(name: "Drinks", restockNum: 10)
    static let drinkItems: [ItemEntity] = ItemEntity.drinkArray
    
    static let frozenCategory: DepartmentEntity = DepartmentEntity(name: "Frozen", restockNum: 10)
    static let frozenItems: [ItemEntity] = ItemEntity.frozenArray
    
    static let categoryArray = [foodCategory, drinkCategory, frozenCategory]
    
    static var previewRealm: Realm {
//        let migrator: RealmMigrator = RealmMigrator()
        var realm: Realm
        let identifier = "previewRealm"
        let config = Realm.Configuration(inMemoryIdentifier: identifier)
        do {
            realm = try Realm(configuration: config)
                if realm.isEmpty {
                    // MARK: - CREATE PREVIEW DATA
                    debugPrint("Creating preview data")
                    try realm.write {
                        realm.add(company)
                        
                        realm.add(foodCategory)
                        
                        foodCategory.items.append(objectsIn: ItemEntity.foodArray)
                        
                        
                        realm.add(drinkCategory)
                        drinkCategory.items.append(objectsIn: ItemEntity.drinkArray)
                        
                        realm.add(frozenCategory)
                        frozenCategory.items.append(objectsIn: ItemEntity.frozenArray)
                    }
                    return realm
                } else {
                    debugPrint("Deleting preview data")
                    let realm = try Realm()
                    try realm.write {
                        realm.deleteAll()
                    }
                    return realm
                    
                }
            
            
        } catch {
            fatalError("Can't bootstrap item data: \(error.localizedDescription)")
        }
    }
}
