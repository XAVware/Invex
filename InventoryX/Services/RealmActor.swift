//
//  RealmActor.swift
//  InventoryX
//
//  Created by Ryan Smetana on 4/15/24.
//

import Foundation
import RealmSwift


/// TODO: Should be:
/// 1. detailViewSubmitted() should pass the current Object to the view model.
/// 2. View model should do validation of form field types before passing the cleaned data to RealmActor.
/// 3. Query to check if Object exists.
///     - If it does, the user is modifying.
///     - If not, the user is creating a new object.

// TODO: Move form validation back into ViewModels. Only pass this actor type validated data so it is easier to troubleshoot.
actor RealmActor {
    
    @MainActor
    func fetchCompany() throws -> CompanyEntity? {
        let realm = try Realm()
        return realm.objects(CompanyEntity.self).first
    }
    
    @MainActor
    func deleteDepartment(id: RealmSwift.ObjectId) async throws {
        let realm = try await Realm()
        guard let dept = realm.object(ofType: DepartmentEntity.self,
                                      forPrimaryKey: id) else { throw AppError.departmentDoesNotExist }
        guard dept.items.isEmpty else { throw AppError.departmentHasItems }
        
        try await realm.asyncWrite {
            realm.delete(dept)
        }
    }
    
    @MainActor func moveItems(from fromDept: DepartmentEntity, to toDept: DepartmentEntity) async throws {
        let realm = try await Realm()
        let itemsToMove = fromDept.items
        guard itemsToMove.count > 0 else {
            debugPrint("Department has no items to move")
            return
        }
        guard let fromDept = fromDept.thaw(), let toDept = toDept.thaw() else { throw AppError.thawingDepartmentError }
        try await realm.asyncWrite {
            toDept.items.append(objectsIn: itemsToMove)
            fromDept.items.removeAll()
        }
    }
    
    @MainActor
    func moveItems(withIds itemIds: [ObjectId], toDepartmentId: ObjectId) async throws {
        let realm = try await Realm()
        guard let targetDept = realm.object(ofType: DepartmentEntity.self, forPrimaryKey: toDepartmentId) else {
            return
        }
        
        try await realm.asyncWrite {
            for itemId in itemIds {
                if let item = realm.object(ofType: ItemEntity.self, forPrimaryKey: itemId),
                   let sourceDept = item.department.first {
                    sourceDept.items.remove(at: sourceDept.items.firstIndex(of: item)!)
                    targetDept.items.append(item)
                }
            }
        }
    }
    
    @MainActor
    func deleteItems(withIds itemIds: [ObjectId]) async throws {
        let realm = try await Realm()
        try await realm.asyncWrite {
            for itemId in itemIds {
                if let item = realm.object(ofType: ItemEntity.self, forPrimaryKey: itemId) {
                    realm.delete(item)
                }
            }
        }
    }
    
    // MARK: - SALES
    func saveSale(items: Array<SaleItemEntity>, total: Double) async throws {
        let newSale = SaleEntity(timestamp: Date(), total: total)
        
        let realm = try await Realm()
        try await realm.asyncWrite {
            realm.add(newSale)
            newSale.items.append(objectsIn: items)
        }
    }
    
    func deleteAll() async throws {
        let realm = try await Realm()
        try await realm.asyncWrite {
            realm.deleteAll()
        }
    }
}
