//
//  DataService.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/18/24.
//

import Foundation
import RealmSwift

/// DataService needs to remain a `@MainActor` because until a full migration is done from
/// using the @ObservedResults property wrappers to using DataService entirely. Since Realm
/// is being used on the main thread via the ObservedResults property wrapper, all reads/writes/
/// etc. need to be done on the main thread
///
///

/// If a threading error is thrown here in the future, DataService may need to be marked as a main actor ~ originally due to error while adding department.


/// `DataService` handles all communications with Realm. Duplicate department names should be handled here.
class DataService {
    
    private let migrator: RealmMigrator = RealmMigrator()
    
    static let shared = DataService()
    
    private init() { }
    
    static func addDepartment(dept: DepartmentEntity) async throws {
        let realm = try await Realm()
        try await realm.asyncWrite { realm.add(dept) }
    }
    
    static func resetRealm() async throws {
        let realm = try await Realm()
        try await realm.asyncWrite { realm.deleteAll() }
    }
    
    static func add(_ item: ItemEntity, to department: DepartmentEntity) async throws {
        let realm = try await Realm()
        try await realm.asyncWrite { department.items.append(item) }
    }
    
    static func fetchDepartment(named name: String) async throws -> DepartmentEntity? {
        let realm = try await Realm()
        return realm.objects(DepartmentEntity.self).first { $0.name == name }
//        guard let selectedCategory = realm.objects(CategoryEntity.self).where({ tempCategory in
//            tempCategory.name == categoryName
//        }).first else {
//            print("Error setting selected category.")
//            return
//        }
    }
    
    static func fetchItem(withId id: ObjectId) async throws -> ItemEntity? {
        let realm = try await Realm()
        return realm.object(ofType: ItemEntity.self, forPrimaryKey: id)
    }
    
    static func updateItemOnHandQty(_ item: ItemEntity, newQty: Int) async throws {
        let realm = try await Realm()
        try await realm.asyncWrite {
            item.onHandQty = newQty
        }
    }
    
    static func saveSale(_ sale: SaleEntity) async throws {
        let realm = try await Realm()
        try await realm.asyncWrite { realm.add(sale) }
    }
    
    static func saveSales(_ sales: [SaleEntity]) async throws {
        let realm = try await Realm()
        try await realm.asyncWrite { realm.add(sales) }
    }
    
}

/// Supplemental functions for ease of development
extension DataService {
    static func createRandomSales(qty: Int) async throws {
        var sales: [SaleEntity] = []
        for _ in 0 ..< qty {
            let randomSeconds = Int.random(in: 0 ... 2628288)
            let newSale = SaleEntity(timestamp: Date(timeIntervalSinceNow: -Double(randomSeconds)), total: Double(randomSeconds / 1000))
            sales.append(newSale)
        }
        
        try await self.saveSales(sales)
    }
    
    static func createRandomSalesToday(qty: Int) async throws {
        var sales: [SaleEntity] = []
        for _ in 0 ..< qty {
            let randomSeconds = Int.random(in: 0 ... 43200)
            let newSale = SaleEntity(timestamp: Date(timeIntervalSinceNow: -Double(randomSeconds)), total: Double(randomSeconds / 1000))
            sales.append(newSale)
        }
        try await self.saveSales(sales)
    }
}
