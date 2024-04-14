//
//  CompanyDetailView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/25/24.
//

import SwiftUI
import RealmSwift

@MainActor class CompanyDetailViewModel: ObservableObject {
    
    /// Company data saves differently than departments and items. Since there can 
    /// only be one company there's no need to track create/modify states. When the
    /// save button is tapped, check if a company exists, if yes then `modify/update`
    /// otherwise `create`.
    func saveCompany(name: String, tax: String) throws {
        guard let taxRate = Double(tax) else { throw AppError.invalidTaxPercentage }
        // Confirm name is valid after whitespace is removed.
        let company = CompanyEntity(name: name, taxRate: taxRate)
        let realm = try Realm()
        
        try realm.write {
            if let company = realm.objects(CompanyEntity.self).first {
                // Company exists, update record
                debugPrint("Company already exists, updating the record.")
                company.name = name
                company.taxRate = taxRate
            } else {
                // Company doesn't exist. Create record
                debugPrint("Creating company record.")
                realm.add(company)
            }
        }
        
        if let company = realm.objects(CompanyEntity.self).first {
            // Company exists, update record
            debugPrint("Company already exists, updating the record.")
            try realm.write {
                company.name = name
                company.taxRate = taxRate
            }
        } else {
            // Company doesn't exist. Create record
            debugPrint("Creating company record.")
            try realm.write {
                realm.add(company)
            }
        }
    }
    
}

struct CompanyDetailView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var vm: CompanyDetailViewModel = CompanyDetailViewModel()
    @StateObject var uiFeedback = UIFeedbackService.shared
    let company: CompanyEntity?
    
    @State private var companyName: String = ""
    @State private var taxRate: String = ""
    
    /// Used to hide the back button and title while onboarding.
    @State var showTitles: Bool
    
    /// Used in onboarding view to execute additional logic.
    let onSuccess: (() -> Void)?
    
    private enum Focus { case name, taxRate }
    @FocusState private var focus: Focus?
    
    @State var errorMessage: String = ""
    
    init(company: CompanyEntity?, showTitles: Bool = true, onSuccess: (() -> Void)? = nil) {
        if let company = company {
            self.companyName = company.name
            self.taxRate = company.formattedTaxRate
        }
        
        self.company = company
        self.showTitles = showTitles
        self.onSuccess = onSuccess
    }
    
    private func continueTapped() {
        focus = nil
        do {
            try vm.saveCompany(name: companyName, tax: taxRate)
            finish()
        } catch let error as AppError {
//            UIFeedbackService.shared.showAlert(.error, error.localizedDescription)
            errorMessage = error.localizedDescription
        } catch {
//            UIFeedbackService.shared.showAlert(.error, error.localizedDescription)
            errorMessage = error.localizedDescription
        }
    }
    
    private func finish() {
        if let onSuccess = onSuccess {
            // On success is only used by onboarding view which we don't want to dismiss.
            onSuccess()
        } else {
            dismiss()
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // MARK: - HEADER
                if showTitles {
                    VStack(alignment: .leading, spacing: 8) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                        
                        Text("Edit company info")
                        
                    } //: VStack
                    .modifier(TitleMod())
                }
                
                // MARK: - FORM FIELDS
                VStack(alignment: .leading, spacing: 24) {
                    ThemeTextField(boundTo: $companyName,
                                   placeholder: "Company Name",
                                   title: "Business Name:",
                                   subtitle: nil,
                                   type: .text)
                    .autocorrectionDisabled()
                    .focused($focus, equals: .name)
                    
                    ThemeTextField(boundTo: $taxRate,
                                   placeholder: "0",
                                   title: "Tax Rate:",
                                   subtitle: "If you want us to calculate the tax on your sales, enter a tax rate here.",
                                   type: .percentage)
                    .keyboardType(.numberPad)
                    .focused($focus, equals: .taxRate)
                    
                } //: VStack
                .padding(.vertical, 24)
                .onChange(of: focus) { newValue in
                    guard !taxRate.isEmpty else { return }
                    guard let tax = Double(taxRate) else { return }
                    self.taxRate = tax.toPercentageString()
                }
                
                Text(errorMessage)
                    .foregroundStyle(.red)
                
                Button {
                    continueTapped()
                } label: {
                    Spacer()
                    Text("Continue")
                    Spacer()
                }
                .modifier(PrimaryButtonMod())
                
                Spacer()
            } //: VStack
            .frame(maxWidth: 720)
            .padding()
            .onTapGesture {
                self.focus = nil
            }
        } //: ScrollView
    } //: Body
    
}


#Preview {
    CompanyDetailView(company: nil)
}
