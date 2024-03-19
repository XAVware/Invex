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
    //    @StateObject var userManager: UserManager = UserManager()
//    @StateObject var navMan: NavigationManager = NavigationManager()
    /*let migrator: RealmMigrator = RealmMigrator()*/ // Storing like this is bad for memory. This only needs to run once.
    
//    @ObservedResults(CategoryEntity.self) var categories
//    @ObservedResults(UserEntity.self) var users
    
    let db: DataService = DataService.shared
    
    var body: some Scene {
        WindowGroup {
            GeometryReader { geo in
                ActiveOrderView()
                    .task {
                        do {
                            try await DataService.resetRealm()
                            let drinks = DepartmentEntity(name: "Drinks", restockNum: 12)
                            drinks.items.append(objectsIn: ItemEntity.drinkArray)
                            drinks.items.append(objectsIn: ItemEntity.foodArray)
                            try await DataService.addDepartment(dept: drinks)
                        } catch {
                            print(error)
                        }
                    }
                    .onAppear {
                        print("Main width: \(geo.size.width)")
                    }
            }
//            if categories.count == 0 {
//                OnboardingView()
////                    .environmentObject(userManager)
//            } else {
//                GeometryReader { geo in
//                    ContentView()
//                        .environmentObject(navMan)
//                        .onAppear {
//                            print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)
//                            UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
//                            //                            navMan.setup(screenWidth: geo.size.width)
////                            print(geo.safeAreaInsets.top)
//                        }
//                        .statusBar(hidden: true)
//                } //: Geometry Reader
//            }
        }
    } //: Body
}
