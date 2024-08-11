//
//  CompanyDetailView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/25/24.
//

import SwiftUI
import RealmSwift

/// Company detail view is being placed in the inner split view as the root of the NavigationStack, so the navigationDestinations for this funnel need to be included here. You need to use NavigationLink(value:label:) to push the detail views

struct CompanyDetailView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var vm: DetailViewModel = DetailViewModel()
    let company: CompanyEntity?
    @State private var companyName: String = ""
    @State private var taxRate: String = ""
    let detailType: DetailType
    private enum Focus { case name, taxRate }
    @FocusState private var focus: Focus?
    
    let onSuccess: (() -> Void)?
    
    init(company: CompanyEntity?, detailType: DetailType, onSuccess: (() -> Void)? = nil) {
        self._vm = StateObject(wrappedValue: DetailViewModel())
        self.detailType = detailType
        
        if let company = company {
            self.companyName = company.name
            if company.taxRate > 0 {
                self.taxRate = company.formattedTaxRate
            }
        }
        
        self.company = company
        
        self.onSuccess = onSuccess

    }
    
    private func continueTapped() {
        focus = nil
        Task {
            await vm.saveCompany(name: companyName, tax: taxRate) { error in
                guard error == nil else { return }
                if let onSuccess = onSuccess {
                    onSuccess()
                } else {
                    dismiss()
                }
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                Text(vm.errorMessage)
                    .foregroundStyle(.red)
                
                VStack(alignment: .leading, spacing: 24) {
                    ThemeTextField(boundTo: $companyName,
                                   placeholder: "Company Name",
                                   title: "Business Name:",
                                   subtitle: nil,
                                   type: .text)
                    .autocorrectionDisabled()
                    .focused($focus, equals: .name)
                    .submitLabel(.return)
                    .onSubmit { focus = nil }
                    
                    
                    ThemeTextField(boundTo: $taxRate,
                                   placeholder: "0",
                                   title: "Tax Rate:",
                                   subtitle: "If you want us to calculate the tax on your sales, enter a tax rate here.",
                                   type: .percentage)
                    .keyboardType(.numberPad)
                    .focused($focus, equals: .taxRate)
                    .submitLabel(.return)
                    .onSubmit { focus = nil }
                    
                } //: VStack
                .padding(.vertical, 24)
                .onChange(of: focus) { _, newValue in
                    guard !taxRate.isEmpty else { return }
                    guard let tax = Double(taxRate) else { return }
                    guard tax != 0 else { return }
                    self.taxRate = tax.toPercentageString()
                }

                
               
                Spacer()
                continueButton
                Spacer()
            } //: VStack
            .navigationTitle("Company info")
            .navigationBarTitleDisplayMode(.large)
            .frame(maxWidth: 720)
            .padding()
            .onTapGesture {
                self.focus = nil
            }
            .background(Color.clear)
        } //: Scroll
        .scrollIndicators(.hidden)
    } //: Body
    
    private var continueButton: some View {
        Button {
            continueTapped()
        } label: {
            Spacer()
            Text("Continue")
            Spacer()
        }
        .modifier(PrimaryButtonMod())
        .padding()
        .padding(.bottom, 24)
    }
}


//#Preview {
//    CompanyDetailView(company: nil, detailType: .onboarding) {}
//}
