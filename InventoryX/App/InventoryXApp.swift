//
//  InventoryXApp.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/19/23.
//

import SwiftUI
import RealmSwift

@main
struct InventoryXApp: SwiftUI.App {
    let migrator: RealmMigrator = RealmMigrator()
    
    
    func addSampleData() {
        let drinks = DepartmentEntity(name: "Drinks", restockNum: 12)
        drinks.items.append(objectsIn: ItemEntity.drinkArray)
        drinks.items.append(objectsIn: ItemEntity.foodArray)
        let realm = try! Realm()
        try! realm.write {
            realm.add(drinks)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ResponsiveView { props in
                RootView(uiProperties: props)
            }
            .onAppear {
                //                UserDefaults.standard.setValue(true, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                //                UserDefaults.standard.removeObject(forKey: "passcode")
                //                let realm = try! Realm()
                //                try! realm.write { realm.deleteAll() }
            }
        }
    } //: Body
}

