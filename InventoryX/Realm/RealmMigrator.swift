//
//  Migrator.swift
//  InventoryX
//
//  Created by Ryan Smetana on 4/27/23.
//

import SwiftUI
import RealmSwift

class RealmMigrator {
    init(currentSchemaVersion: UInt64) {
        updateSchema(to: currentSchemaVersion)
    }
    
    func updateSchema(to currentVersion: UInt64) {
        let config = Realm.Configuration(schemaVersion: currentVersion, migrationBlock: { migration, oldSchemaVersion in
            if (oldSchemaVersion < currentVersion) {
                migration.enumerateObjects(ofType: CategoryEntity.className()) { oldObject, newObject in }
                migration.enumerateObjects(ofType: InventoryItemEntity.className()) { (oldObject, newObject) in }
                migration.enumerateObjects(ofType: ChildInventoryItemEntity.className()) { (oldObject, newObject) in }
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
