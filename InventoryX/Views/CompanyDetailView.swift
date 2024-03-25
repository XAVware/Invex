//
//  CompanyDetailView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/25/24.
//

import SwiftUI
import RealmSwift

@MainActor class CompanyDetailViewModel: ObservableObject {
    func saveCompany(name: String, tax: String) throws {
        guard let taxRate = Double(tax) else { throw AppError.invalidTaxPercentage }
        // Confirm name is valid after whitespace is removed.
        let company = CompanyEntity(name: name, taxRate: taxRate)
        let realm = try Realm()
        try realm.write {
            realm.add(company)
        }

    }
}

struct CompanyDetailView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var vm: CompanyDetailViewModel = CompanyDetailViewModel()
    
    let company: CompanyEntity?
    
    @State private var companyName: String = ""
    @State private var taxRate: String = ""
    
    /// Used to hide the back button and title while onboarding.
    @State var showTitles: Bool
    
    /// Used in onboarding view to execute additional logic.
    let onSuccess: (() -> Void)?
    
    @State var detailState: DetailViewType
    
    init(company: CompanyEntity?, showTitles: Bool = true, onSuccess: (() -> Void)? = nil) {
        if let company = company {
            detailState = .modify
            companyName = company.name
            taxRate = String(describing: company.taxRate)
        } else {
            detailState = .create
        }
        self.company = company
        self.showTitles = showTitles
        self.onSuccess = onSuccess
    }
    
    private func continueTapped() {
        switch detailState {
        case .create:
            do {
                try vm.saveCompany(name: companyName, tax: taxRate)
                onSuccess?()
            } catch {
                print("Error while saving company: \(error.localizedDescription)")
            }
        case .view:
            return
        case .modify:
            return
        }
    }
    
    var body: some View {
        VStack(spacing: 24) {
            if showTitles {
                VStack(alignment: .leading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24)
                            .foregroundStyle(.black)
                    }
                    
                    Text("Edit company info")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                } //: VStack
                .frame(maxWidth: 720)
            }
            
            ThemeTextField(boundTo: $companyName,
                           placeholder: "Company Name",
                           title: "Business Name:",
                           subtitle: nil,
                           type: .text,
                           layout: .vertical)

            Divider()
            
            ThemeTextField(boundTo: $taxRate,
                           placeholder: "0",
                           title: "Tax Rate:",
                           subtitle: "If you want us to calculate the tax on your sales, enter a tax rate here.",
                           type: .percentage,
                           layout: .horizontal)
            .frame(height: 96)
            
            Spacer()
            
            Button {
                continueTapped()
            } label: {
                Text("Continue")
            }
            .modifier(PrimaryButtonMod())
        } //: VStack
        .padding()
        .frame(maxWidth: 720)
    }
}


#Preview {
    CompanyDetailView(company: nil)
}
