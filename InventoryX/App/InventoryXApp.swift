//
//  InventoryXApp.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/19/23.
//

/*
 User defined build settings:
 DISABLE_DIAMOND_PROBLEM_DIAGNOSTIC = YES was added to resolve an error of "Showing All Issues Swift package target 'Realm' is linked as a static library by 'InventoryX' and 'Realm', but cannot be built dynamically because there is a package product with the same name."
 
 */

import SwiftUI
import RealmSwift

@main
struct InventoryXApp: SwiftUI.App {
    let migrator: RealmMigrator = RealmMigrator()
    
    func addSampleData() {
        let drinksDept = DepartmentEntity(name: "Drinks", restockNum: 12, defMarkup: 0.5)
        drinksDept.items.append(objectsIn: ItemEntity.drinkArray)
        
        let snacksDept = DepartmentEntity(name: "Snacks", restockNum: 15, defMarkup: 0.2)
        snacksDept.items.append(objectsIn: ItemEntity.snackArray)
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(drinksDept)
            realm.add(snacksDept)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ResponsiveView { props in
                RootView(uiProperties: props)
            }
            .onAppear {
//                addSampleData()
                //                UserDefaults.standard.setValue(true, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
            }
        }
    } //: Body
}




