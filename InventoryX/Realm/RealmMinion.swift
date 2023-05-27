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
    }
    
    
}
