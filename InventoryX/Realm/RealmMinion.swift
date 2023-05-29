//
//  RealmMinion.swift
//  InventoryX
//
//  Created by Ryan Smetana on 5/26/23.
//

import SwiftUI
import RealmSwift


// Data should be cleaned and error handled before being passed to this class.
// This will allow redundant code to be moved away from ViewModels.
class RealmMinion {
    
    static func addNewItem(newItem: InventoryItemEntity, categoryName: String, completion: @escaping () -> Void) {
        do {
            let realm = try Realm()
            guard let selectedCategory = realm.objects(CategoryEntity.self).where({ tempCategory in
                tempCategory.name == categoryName
            }).first else {
                print("Error setting selected category.")
                return
            }
            
            let originalItems = selectedCategory.items
            
            try realm.write {
                let newItemsList = originalItems
                newItemsList.append(newItem)
                selectedCategory.items = newItemsList
            }
            
            completion()
        } catch {
            print(error.localizedDescription)
        }
    } //: Add New Item
    
    static func deleteAllFromRealm() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print(error.localizedDescription)
        }
    } //: Delete All From Realm
    
    static func createRandomSales(qty: Int) {
        var sales: [SaleEntity] = []
        for _ in 0 ..< qty {
            let randomSeconds = Int.random(in: 0 ... 2628288)
            let newSale = SaleEntity(timestamp: Date(timeIntervalSinceNow: -Double(randomSeconds)), total: Double(randomSeconds / 1000))
            sales.append(newSale)
        }
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(sales)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
