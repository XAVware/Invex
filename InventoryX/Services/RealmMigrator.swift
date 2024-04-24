//
//  Migrator.swift
//  InventoryX
//
//  Created by Ryan Smetana on 4/27/23.
//

import SwiftUI
import RealmSwift

/// Class used for easier Realm migration.
/// The schemaVersion was previously included in @main but was moved here so all Realm versioning can be handled in one place.
class RealmMigrator {
    let currentSchemaVersion: UInt64 = 59
    
    init() {
        let config = Realm.Configuration(schemaVersion: currentSchemaVersion, migrationBlock: { migration, oldSchemaVersion in
            if (oldSchemaVersion < self.currentSchemaVersion) {
                migration.enumerateObjects(ofType: DepartmentEntity.className()) { oldObject, newObject in }
                migration.enumerateObjects(ofType: ItemEntity.className()) { (oldObject, newObject) in }
                migration.enumerateObjects(ofType: SaleEntity.className()) { oldObject, newObject in }
                migration.enumerateObjects(ofType: SaleItemEntity.className()) { oldObject, newObject in }
            }
        })
        
        do {
            _ = try Realm(configuration: config)
        } catch {
            debugPrint("Error initializing Realm:\n \(error.localizedDescription)")
        }
    }
    
}
