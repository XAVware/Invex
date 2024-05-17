//
//  AddItemViewModel.swift
//  InventoryX
//
//  Created by Ryan Smetana on 5/11/24.
//

import Foundation
import RealmSwift

@MainActor class AddItemViewModel: ObservableObject {
    @Published var errorMessage: String = ""
    
    func getFirstDept() async -> DepartmentEntity?  {
        let departments = try? await RealmActor().fetchDepartments()
        return departments?.first ?? nil
    }
    
    func saveItem(
        dept: DepartmentEntity?,
        name: String,
        att: String,
        qty: String,
        price: String,
        cost: String,
        completion: @escaping ((Error?) -> Void)
    ) async {
        do {
            try await RealmActor().saveItem(dept: dept, name: name, att: att, qty: qty, price: price, cost: cost)
            completion(nil)
        } catch let error as AppError {
            errorMessage = error.localizedDescription
            completion(error)
        } catch {
            errorMessage = error.localizedDescription
            completion(error)
        }
    } //: Save Item
    
    
    func updateItem(
        item: ItemEntity,
        name: String,
        att: String,
        qty: String,
        price: String,
        cost: String,
        completion: @escaping ((Error?) -> Void)
    ) async {
        do {
            try await RealmActor().updateItem(item: item, name: name, att: att, qty: qty, price: price, cost: cost)
            completion(nil)
        } catch let error as AppError {
            errorMessage = error.localizedDescription
            completion(error)
        } catch {
            errorMessage = error.localizedDescription
            completion(error)
        }
    }
    
    func deleteItem(withId id: ObjectId, completion: @escaping ((Error?) -> Void)) async {
        do {
            try await RealmActor().deleteItem(withId: id)
            completion(nil)
        } catch let error as AppError {
            errorMessage = error.localizedDescription
            completion(error)
        } catch {
            errorMessage = error.localizedDescription
            completion(error)
        }
    }
    
    
}
