//
//  ContentView.swift
//  ConcessionTracker
//
//  Created by Ryan Smetana on 1/20/21.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    var body: some View {
        AddInventoryView()
    }
    
    init() {
        let config = Realm.Configuration(
            schemaVersion: 1,
            
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                    migration.enumerateObjects(ofType: Item.className()) { (oldObject, newObject) in
                        
                    }
                    migration.enumerateObjects(ofType: Sale.className()) { oldObject, newObject in
                        
                    }
                }
            })
        Realm.Configuration.defaultConfiguration = config
        do {
            _ = try Realm()
        } catch let error as NSError {
            print("Error initializing realm with error-- \(error.localizedDescription)")
        }
    }
}
