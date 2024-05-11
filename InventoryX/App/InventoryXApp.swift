//
//  InventoryXApp.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/19/23.
//

/// To Do List
/// - Apple changes from version 1

/// - Sort/Filter Item List
/// - Pass width to cart and menu enums to determine states for device size
/// - Make detailViews Generic
/// - Improve animations and UI of cart and menu
/// - Receive inventory
/// - Implement UIFeedback Service for Alerts
/// - Department default markup
/// - Item cost, margin, markup
/// - Amount tendered
/// - change item department
/// - Lock screen dismisses on orientation change
/// - Table row background
/// - Move detail views from sheets to side like cart
///


// MARK: - Future Features
/// - Sales History
/// - Print receipt
/// - CSV Upload
/// - Look up item data from UPC with camera
/// - Option to change color theme
/// - Email inventory report
/// - Multiple accounts

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
                NewRootView(uiProperties: props)
            }
            .onAppear {
//                addSampleData()
                //                UserDefaults.standard.setValue(true, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
            }
        }
    } //: Body
}




