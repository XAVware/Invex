//
//  RealmActor_Ext.swift
//  InventoryX
//
//  Created by Ryan Smetana on 5/11/24.
//

import Foundation
import RealmSwift

extension RealmActor {
    @MainActor func setUpForDebug() async throws {
        print("Setting up for debug")
        try await deleteAll()
        print("Erased previous Realm data")
        let debugCompany = CompanyEntity(name: "XAVware, LLC", taxRate: 0.07)
        
        let drinksDept = DepartmentEntity(name: "Drinks", restockNum: 12, defMarkup: 0.5)
        drinksDept.items.append(objectsIn: [
            ItemEntity(name: "Water", attribute: "Cold", retailPrice: 1.0, avgCostPer: 0.25, onHandQty: 150),
            ItemEntity(name: "Iced Tea", attribute: "Cold", retailPrice: 1.5, avgCostPer: 0.45, onHandQty: 80),
            ItemEntity(name: "Coffee", attribute: "Hot", retailPrice: 2.0, avgCostPer: 0.5, onHandQty: 90),
            ItemEntity(name: "Smoothie", attribute: "Cold", retailPrice: 3.5, avgCostPer: 1.0, onHandQty: 60),
            ItemEntity(name: "Energy Drink", attribute: "Cold", retailPrice: 2.0, avgCostPer: 0.9, onHandQty: 85),
            ItemEntity(name: "Beer", attribute: "Cold", retailPrice: 4.0, avgCostPer: 1.5, onHandQty: 100),
            ItemEntity(name: "Soda", attribute: "Cold", retailPrice: 1.5, avgCostPer: 0.4, onHandQty: 120),
            ItemEntity(name: "Milkshake", attribute: "Cold", retailPrice: 3.0, avgCostPer: 1.2, onHandQty: 50),
            ItemEntity(name: "Hot Chocolate", attribute: "Hot", retailPrice: 2.5, avgCostPer: 0.8, onHandQty: 70),
            ItemEntity(name: "Fruit Juice", attribute: "Cold", retailPrice: 2.0, avgCostPer: 0.6, onHandQty: 90)
        ])
        
        let snacksDept = DepartmentEntity(name: "Snacks", restockNum: 15, defMarkup: 0.2)
        snacksDept.items.append(objectsIn: [
            ItemEntity(name: "Chips", attribute: "Packaged", retailPrice: 1.0, avgCostPer: 0.4, onHandQty: 100),
            ItemEntity(name: "Nachos", attribute: "Hot", retailPrice: 3.5, avgCostPer: 1.0, onHandQty: 50),
            ItemEntity(name: "Pretzel", attribute: "Hot", retailPrice: 2.0, avgCostPer: 0.5, onHandQty: 80),
            ItemEntity(name: "Candy", attribute: "Sweet", retailPrice: 1.5, avgCostPer: 0.3, onHandQty: 150),
            ItemEntity(name: "Sandwich", attribute: "Cold", retailPrice: 4.0, avgCostPer: 2.0, onHandQty: 60),
            ItemEntity(name: "Cookies", attribute: "Packaged", retailPrice: 2.0, avgCostPer: 0.7, onHandQty: 100),
            ItemEntity(name: "Burger", attribute: "Hot", retailPrice: 5.0, avgCostPer: 2.5, onHandQty: 40),
            ItemEntity(name: "Pizza Slice", attribute: "Hot", retailPrice: 3.0, avgCostPer: 1.1, onHandQty: 75),
            ItemEntity(name: "Ice Cream", attribute: "Cold", retailPrice: 2.5, avgCostPer: 0.9, onHandQty: 65),
            ItemEntity(name: "Muffin", attribute: "Packaged", retailPrice: 2.5, avgCostPer: 0.8, onHandQty: 80)
        ])
        
        let realm = try await Realm()
        try await realm.asyncWrite {
            realm.add(debugCompany)
            realm.add(drinksDept)
            realm.add(snacksDept)
        }
    }
}
