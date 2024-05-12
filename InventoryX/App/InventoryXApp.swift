//
//  InventoryXApp.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/19/23.
//

/*
 User defined build settings:
 DISABLE_DIAMOND_PROBLEM_DIAGNOSTIC = YES was added to resolve an error of "Showing All Issues Swift package target 'Realm' is linked as a static library by 'InventoryX' and 'Realm', but cannot be built dynamically because there is a package product with the same name."
 
 
 .onAppear {
    // To fix an issue at some point I added this.
    UserDefaults.standard.setValue(true, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
 
 }
 
 */

import SwiftUI
import RealmSwift

extension RealmActor {
    @MainActor func setUpForDebug() async throws {
        print("Setting up for debug")
        try await deleteAll()
        print("Erased previous Realm data")
        let debugCompany = CompanyEntity(name: "XAVware, LLC", taxRate: 0.07)
        
        let drinksDept = DepartmentEntity(name: "Drinks", restockNum: 12, defMarkup: 0.5)
        drinksDept.items.append(objectsIn: ItemEntity.drinkArray)
        
        let snacksDept = DepartmentEntity(name: "Snacks", restockNum: 15, defMarkup: 0.2)
        snacksDept.items.append(objectsIn: ItemEntity.snackArray)
        
        let realm = try await Realm()
        try await realm.asyncWrite {
            realm.add(debugCompany)
            realm.add(drinksDept)
            realm.add(snacksDept)
        }
    }
}

@main
struct InventoryXApp: SwiftUI.App {
    let IS_DEBUG: Bool = true
    
    let migrator: RealmMigrator = RealmMigrator()
    
    var body: some Scene {
        WindowGroup {
            ResponsiveView { props in
                RootView(uiProperties: props)
            }
            .onAppear {
                if IS_DEBUG {
                    Task {
                        try await RealmActor().setUpForDebug()
                    }
                }
            }
        }
    } //: Body
}




