//
//  SettingsViewModel.swift
//  InventoryX
//
//  Created by Ryan Smetana on 5/11/24.
//

import Foundation

@MainActor class SettingsViewModel: ObservableObject {
    @Published var companyName: String = ""
    @Published var taxRateStr: String = ""
        
    init() {
        fetchCompanyData()
    }
    
    func fetchCompanyData() {
        do {
            if let company = try RealmActor().fetchCompany() {
                self.companyName = company.name
                self.taxRateStr = String(format: "%.2f%", Double(company.taxRate))
            }
        } catch {
            debugPrint(error.localizedDescription)
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
