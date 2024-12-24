//
//  AddItemViewModel.swift
//  InventoryX
//
//  Created by Ryan Smetana on 5/11/24.
//

import Foundation
import RealmSwift

@MainActor class DetailViewModel: ObservableObject {
    @Published var errorMessage: String?

    func saveItem(dept: DepartmentEntity?, name: String, att: String, qty: String, price: String, cost: String, completion: @escaping ((Error?) -> Void)) async {
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
    
    
    func updateItem( item: ItemEntity, name: String, att: String, qty: String, price: String, cost: String, completion: @escaping ((Error?) -> Void)) async {
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

extension DetailViewModel {
    // Company
    func saveCompany(name: String, tax: String, completion: @escaping ((Error?) -> Void)) async {
        do {
            try await RealmActor().saveCompany(name: name, tax: tax)
            completion(nil)
        } catch let error as AppError {
            errorMessage = error.localizedDescription
            completion(error)
        } catch {
            errorMessage = error.localizedDescription
            completion(error)
        }
    }
    
    func deleteAccount() async {
        do {
            try await RealmActor().deleteAll()
        } catch {
            print("Error deleting account: \(error.localizedDescription)")
        }
    }

}

extension DetailViewModel {
    // Department
    func save(name: String, threshold: String, markup: String, completion: @escaping ((Error?) -> Void)) async {
        do {
            try await RealmActor().addDepartment(name: name, restockThresh: threshold, markup: markup)
            completion(nil)
        } catch let error as AppError {
            errorMessage = error.localizedDescription
            completion(error)
        } catch {
            errorMessage = error.localizedDescription
            completion(error)
        }
    }
    
    func deleteDepartment(withId id: RealmSwift.ObjectId, completion: @escaping ((Error?) -> Void)) async {
        do {
            try await RealmActor().deleteDepartment(id: id)
            completion(nil)
        } catch let error as AppError {
            errorMessage = error.localizedDescription
            completion(error)
        } catch {
            errorMessage = error.localizedDescription
            completion(error)
        }
    }
    
    func update(department: DepartmentEntity, name: String, threshold: String, markup: String, completion: @escaping ((Error?) -> Void)) async {
        do {
            try await RealmActor().updateDepartment(dept: department, newName: name, thresh: threshold, markup: markup)
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
