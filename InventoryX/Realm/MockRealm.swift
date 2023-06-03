//
//  MockRealm.swift
//  InventoryX
//
//  Created by Ryan Smetana on 4/27/23.
//

import SwiftUI
import RealmSwift


/// Class allows Realm to work in SwiftUI previews by adding sample data to the local Realm.
class MockRealms {
    static var config: Realm.Configuration {
        MockRealms.previewRealm.configuration
    }
    
    static var previewRealm: Realm = {
        var realm: Realm
        let identifier = "previewRealm"
        let config = Realm.Configuration(inMemoryIdentifier: identifier)
        do {
            realm = try Realm(configuration: config)
            let category1 = CategoryEntity.foodCategory
            let category2 = CategoryEntity.drinkCategory
            let category3 = CategoryEntity.frozenCategory
            let sale1 = SaleEntity.todaySale1
            
            try realm.write {
                realm.add(category1)
                realm.add(category2)
                realm.add(category3)
                realm.add(sale1)
                category1.items.append(objectsIn: InventoryItemEntity.foodArray)
                category2.items.append(objectsIn: InventoryItemEntity.drinkArray)
                category3.items.append(objectsIn: InventoryItemEntity.frozenArray)
                sale1.items.append(objectsIn: [SaleItemEntity.saleItem1, SaleItemEntity.saleItem2])
            }
            return realm
        } catch let error {
            fatalError("Error: \(error.localizedDescription)")
        }
    }()
}
