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
    
//    init() {
//        UIColor.classInit
//    }
    
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
//                RootView(uiProperties: props)
                NavExperiment(uiProperties: props)
            }
            .onAppear {
//                addSampleData()
                //                UserDefaults.standard.setValue(true, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
            }
        }
    } //: Body
}




