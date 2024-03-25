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
    let migrator: RealmMigrator = RealmMigrator()
//    let db: DataService = DataService.shared
    
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
//                            let realm = try await Realm()
//                            try await realm.asyncWrite { realm.deleteAll() }
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


/// Supplemental functions for ease of development
//extension DataService {
//    static func createRandomSales(qty: Int) async throws {
//        var sales: [SaleEntity] = []
//        for _ in 0 ..< qty {
//            let randomSeconds = Int.random(in: 0 ... 2628288)
//            let newSale = SaleEntity(timestamp: Date(timeIntervalSinceNow: -Double(randomSeconds)), total: Double(randomSeconds / 1000))
//            sales.append(newSale)
//        }
//
//        try await self.saveSales(sales)
//    }
//
//    static func createRandomSalesToday(qty: Int) async throws {
//        var sales: [SaleEntity] = []
//        for _ in 0 ..< qty {
//            let randomSeconds = Int.random(in: 0 ... 43200)
//            let newSale = SaleEntity(timestamp: Date(timeIntervalSinceNow: -Double(randomSeconds)), total: Double(randomSeconds / 1000))
//            sales.append(newSale)
//        }
//        try await self.saveSales(sales)
//    }
//}
