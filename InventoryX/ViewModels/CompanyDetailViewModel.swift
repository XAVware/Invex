//
//  CompanyDetailViewModel.swift
//  InventoryX
//
//  Created by Ryan Smetana on 5/11/24.
//

import Foundation

@MainActor class CompanyDetailViewModel: ObservableObject {
    @Published var errorMessage: String = ""

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

}
