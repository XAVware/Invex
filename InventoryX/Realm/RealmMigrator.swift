//
//  Migrator.swift
//  InventoryX
//
//  Created by Ryan Smetana on 4/27/23.
//

import SwiftUI
import RealmSwift


/// Class used for easier Realm migration.
///The schemaVersion was previously included in @main but was moved here so all Realm versioning can be handled in one place.
class RealmMigrator {
    let currentSchemaVersion: UInt64 = 48
    
    init() {
        let config = Realm.Configuration(schemaVersion: currentSchemaVersion, migrationBlock: { migration, oldSchemaVersion in
            if (oldSchemaVersion < self.currentSchemaVersion) {
                migration.enumerateObjects(ofType: CategoryEntity.className()) { oldObject, newObject in }
                migration.enumerateObjects(ofType: InventoryItemEntity.className()) { (oldObject, newObject) in }
                migration.enumerateObjects(ofType: SaleEntity.className()) { oldObject, newObject in }
                migration.enumerateObjects(ofType: SaleItemEntity.className()) { oldObject, newObject in }
                migration.enumerateObjects(ofType: UserEntity.className()) { oldObject, newObject in }
            }
        })
        
        do {
            _ = try Realm(configuration: config)
        } catch {
            print("Error initializing Realm -->\n \(error.localizedDescription)")
            print("~~~~End Error~~~~")
        }
    }
    
}
