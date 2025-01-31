//
//  AddItemViewModel.swift
//  InventoryX
//
//  Created by Ryan Smetana on 5/11/24.
//

import Foundation
import RealmSwift

@MainActor class DetailViewModel: ObservableObject {
    func deleteAccount() async {
        do {
            try await RealmActor().deleteAll()
        } catch {
            print("Error deleting account: \(error.localizedDescription)")
        }
    }
}
