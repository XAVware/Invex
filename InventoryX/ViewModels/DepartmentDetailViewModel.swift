//
//  DepartmentDetailViewModel.swift
//  InventoryX
//
//  Created by Ryan Smetana on 5/11/24.
//

import Foundation
import RealmSwift

@MainActor class DepartmentDetailViewModel: ObservableObject {
    @Published var errorMessage: String = ""
    
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
