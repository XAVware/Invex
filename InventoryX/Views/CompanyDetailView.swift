//
//  CompanyDetailView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/25/24.
//

import SwiftUI
import RealmSwift

@MainActor class CompanyDetailViewModel: ObservableObject {
    @Published var errorMessage: String = ""

    func saveCompany(name: String, tax: String, completion: @escaping ((Error?) -> Void)) async {
        do {
            try await RealmActor().saveCompany(name: name, tax: tax)
            debugPrint("Successfully saved company")
            completion(nil)
        } catch {
            errorMessage = error.localizedDescription
            print(error.localizedDescription)
            completion(error)
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
        Task {
            await vm.saveCompany(name: companyName, tax: taxRate, completion: { error in
                guard error == nil else { return }
                finish()
            })
            finish()
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
                .onChange(of: focus) { _, newValue in
                    guard !taxRate.isEmpty else { return }
                    guard let tax = Double(taxRate) else { return }
                    self.taxRate = tax.toPercentageString()
                }
                
                Text(vm.errorMessage)
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
