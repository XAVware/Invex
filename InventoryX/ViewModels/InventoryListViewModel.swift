//
//  InventoryListViewModel.swift
//  InventoryX
//
//  Created by Ryan Smetana on 5/11/24.
//

import Foundation
import RealmSwift

@MainActor class InventoryListViewModel: ObservableObject {
    @ObservedResults(DepartmentEntity.self) var departments
    
    @Published var errorMessage = ""
    
    func deleteDepartment(withId id: RealmSwift.ObjectId) async {
        do {
            try await RealmActor().deleteDepartment(id: id)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
}
