//
//  MockRealm.swift
//  InventoryX
//
//  Created by Ryan Smetana on 4/27/23.
//

import SwiftUI
import RealmSwift

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
            try realm.write {
                realm.add(CategoryEntity.categoryArray)
                realm.add(InventoryItemEntity.itemArray)
            }
            return realm
        } catch let error {
            fatalError("Error: \(error.localizedDescription)")
        }
    }()
}
