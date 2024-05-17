//
//  MoveItemsViewModel.swift
//  InventoryX
//
//  Created by Ryan Smetana on 5/11/24.
//

import Foundation

@MainActor class MoveItemsViewModel: ObservableObject {
    func moveItems(from fromDept: DepartmentEntity?, to toDept: DepartmentEntity?, completion: @escaping ((Error?) -> Void)) async {
        guard let fromDept = fromDept, let toDept = toDept else {
            print(AppError.departmentDoesNotExist.localizedDescription)
            return
        }
        
        do {
            try await RealmActor().moveItems(from: fromDept, to: toDept)
            completion(nil)
        } catch {
            print(error.localizedDescription)
            completion(error)
        }
    }
}
