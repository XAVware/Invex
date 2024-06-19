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
        drinksDept.items.append(objectsIn: ItemEntity.drinkArray)
        
        let snacksDept = DepartmentEntity(name: "Snacks", restockNum: 15, defMarkup: 0.2)
        snacksDept.items.append(objectsIn: ItemEntity.snackArray)
        
//        let h = AuthService.shared.hashString("1234")
//        await AuthService.shared.savePasscode(hash: h)
        let realm = try await Realm()
        try await realm.asyncWrite {
            realm.add(debugCompany)
            realm.add(drinksDept)
            realm.add(snacksDept)
        }
        
    }
}
