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
    static let company: CompanyEntity = CompanyEntity(name: "Preview Co.", taxRate: 0.0625)
    
    static let foodCategory: DepartmentEntity = DepartmentEntity(name: "Food", restockNum: 24)
    static let foodItems: [ItemEntity] = ItemEntity.foodArray
    
    static let drinkCategory: DepartmentEntity = DepartmentEntity(name: "Drinks", restockNum: 30)
    static let drinkItems: [ItemEntity] = ItemEntity.drinkArray
    
    static let frozenCategory: DepartmentEntity = DepartmentEntity(name: "Frozen", restockNum: 12)
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
                    company.finishedOnboarding = true
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

//
//  ItemData.swift
//  InventoryX
//
//  Created by Ryan Smetana on 5/11/24.
//

import Foundation


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
    
    static let drinkArray = [
        ItemEntity(name: "Water", attribute: "Cold", retailPrice: 1.0, avgCostPer: 0.25,        onHandQty: 42),
        ItemEntity(name: "Iced Tea", attribute: "Cold", retailPrice: 1.5, avgCostPer: 0.45,     onHandQty: 37),
        ItemEntity(name: "Coffee", attribute: "Hot", retailPrice: 2.0, avgCostPer: 0.5,         onHandQty: 40),
        ItemEntity(name: "Smoothie", attribute: "Cold", retailPrice: 3.5, avgCostPer: 1.0,      onHandQty: 29),
        ItemEntity(name: "Energy Drink", attribute: "Cold", retailPrice: 2.0, avgCostPer: 0.9,  onHandQty: 28),
        ItemEntity(name: "Beer", attribute: "Cold", retailPrice: 4.0, avgCostPer: 1.5,          onHandQty: 43),
        ItemEntity(name: "Soda", attribute: "Cold", retailPrice: 1.5, avgCostPer: 0.4,          onHandQty: 48),
        ItemEntity(name: "Milkshake", attribute: "Cold", retailPrice: 3.0, avgCostPer: 1.2,     onHandQty: 16),
        ItemEntity(name: "Hot Chocolate", attribute: "Hot", retailPrice: 2.5, avgCostPer: 0.8,  onHandQty: 29),
        ItemEntity(name: "Fruit Juice", attribute: "Cold", retailPrice: 2.0, avgCostPer: 0.6,   onHandQty: 32)
    ]
    
    static let snackArray = [
        ItemEntity(name: "Chips", attribute: "Packaged", retailPrice: 1.0, avgCostPer: 0.4,     onHandQty: 41),
        ItemEntity(name: "Nachos", attribute: "Hot", retailPrice: 3.5, avgCostPer: 1.0,         onHandQty: 28),
        ItemEntity(name: "Pretzel", attribute: "Hot", retailPrice: 2.0, avgCostPer: 0.5,        onHandQty: 36),
        ItemEntity(name: "Candy", attribute: "Sweet", retailPrice: 1.5, avgCostPer: 0.3,        onHandQty: 49),
        ItemEntity(name: "Sandwich", attribute: "Cold", retailPrice: 4.0, avgCostPer: 2.0,      onHandQty: 31),
        ItemEntity(name: "Cookies", attribute: "Packaged", retailPrice: 2.0, avgCostPer: 0.7,   onHandQty: 48),
        ItemEntity(name: "Burger", attribute: "Hot", retailPrice: 5.0, avgCostPer: 2.5,         onHandQty: 31),
        ItemEntity(name: "Pizza Slice", attribute: "Hot", retailPrice: 3.0, avgCostPer: 1.1,    onHandQty: 37),
        ItemEntity(name: "Ice Cream", attribute: "Cold", retailPrice: 2.5, avgCostPer: 0.9,     onHandQty: 34),
        ItemEntity(name: "Muffin", attribute: "Packaged", retailPrice: 2.5, avgCostPer: 0.8,    onHandQty: 42)
    ]
}
