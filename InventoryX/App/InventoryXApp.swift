//
//  InventoryXApp.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/19/23.
//

import SwiftUI
import RealmSwift

///
/// Welcome to InventoryX
///
/// The goal of this project was to create a simple Point-of-Sale app to help cash-run businesses keep track of their inventory and track sales.
///
///
/// ---- MODELS ----
/// Every relative object has two model structs/classes. If it is named with 'Entity' it is used to persist data to Realm. If it is named with 'Model' it is meant to use locally as needed.

@main
struct InventoryXApp: SwiftUI.App {
    /// Initialize DataService immediately at launch since it is required for first screen.
    let db: DataService = DataService.shared
    
    var body: some Scene {
        WindowGroup {
            ResponsiveView { props in
                RootView(uiProperties: props)
            }
//                    .onAppear {
//                        UserDefaults.standard.setValue(true, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
//                    }
//                    .task {
//                        do {
//                            UserDefaults.standard.removeObject(forKey: "passcode")
//                            try await DataService.resetRealm()
//                            let drinks = DepartmentEntity(name: "Drinks", restockNum: 12)
//                            drinks.items.append(objectsIn: ItemEntity.drinkArray)
//                            drinks.items.append(objectsIn: ItemEntity.foodArray)
//                            try await DataService.addDepartment(dept: drinks)
//                        } catch {
//                            print(error)
//                        }
//                    }

            
        }
    } //: Body
}
