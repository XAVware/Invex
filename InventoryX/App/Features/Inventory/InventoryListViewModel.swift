//
//  InventoryListViewModel.swift
//  InventoryX
//
//  Created by Ryan Smetana on 5/11/24.
//

import Foundation
import RealmSwift

@Observable
class InventoryViewModel {
    var selectedItems: [ItemEntity] = []
    var showingMoveItems: Bool = false
    var showingDeleteAlert: Bool = false
    
    func multiSelect(_ id: ItemEntity) {
        if selectedItems.contains(id) {
            selectedItems.removeAll(where: { $0 == id })
        } else {
            selectedItems.append(id)
        }
    }
    
    func multiSelect(_ items: [ItemEntity]) {
        if selectedItems.isEmpty {
            selectedItems.append(contentsOf: items)
        } else {
            selectedItems.removeAll()
        }
    }
    
    func deselectAll() {
        selectedItems.removeAll()
    }
    
    func showMoveItems() {
        showingMoveItems = true
    }
    
    func showDeleteAlert() {
        showingDeleteAlert = true
    }
    
    @MainActor
    func moveItemsTo(_ targetDept: DepartmentEntity) {
        Task {
            do {
                let actor = RealmActor()
                let itemIds = selectedItems.map { $0._id }
                let targetDeptId = targetDept._id
                try await actor.moveItems(withIds: itemIds, toDepartmentId: targetDeptId)
                selectedItems.removeAll()
            } catch {
                print("Error moving items: \(error)")
            }
        }
    }
    
    @MainActor
    func deleteSelectedItems() {
        Task {
            do {
                let actor = RealmActor()
                let itemIds = selectedItems.map { $0._id }
                try await actor.deleteItems(withIds: itemIds)
                selectedItems.removeAll()
            } catch {
                print("Error deleting items: \(error)")
            }
        }
    }
    
    func deleteDepartment(withId id: RealmSwift.ObjectId) async {
        do {
            try await RealmActor().deleteDepartment(id: id)
        } catch {
            print("Error deleting department: \(error)")
        }
    }
}
