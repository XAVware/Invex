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
    
    @State var company: CompanyEntity?
    @State private var companyName: String = ""
    @State private var taxRate: String = ""
    
    private enum Focus { case name, taxRate }
    @FocusState private var focus: Focus?
    
    let onSuccess: (() -> Void)?
    
    @ObservedResults(CompanyEntity.self) var companies
    @State var showDeleteConfirmation: Bool = false
    
    init(onSuccess: (() -> Void)? = nil) {
        self._vm = StateObject(wrappedValue: DetailViewModel())
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
                
                NeomorphicSection(header: "General") {
                    VStack(alignment: .leading) {
                        
                        ThemeTextField(boundTo: $companyName,
                                       placeholder: "Business Name",
                                       title: "Business Name:",
                                       hint: nil,
                                       type: .text)
                        .autocorrectionDisabled()
                        .focused($focus, equals: .name)
                        .submitLabel(.return)
                        .onSubmit { focus = nil }
                        
                        FieldDivider()
                        
                        ThemeTextField(boundTo: $taxRate,
                                       placeholder: "0",
                                       title: "Tax Rate:",
                                       hint: "If you want us to calculate the tax on your sales, enter a tax rate here.",
                                       type: .percentage)
                        .keyboardType(.numberPad)
                        .focused($focus, equals: .taxRate)
                        .submitLabel(.return)
                        .onSubmit { focus = nil }
                        
                    } //: VStack
                    .onChange(of: focus) { _, newValue in
                        guard !taxRate.isEmpty else { return }
                        guard let tax = Double(taxRate) else { return }
                        guard tax != 0 else { return }
                        self.taxRate = tax.toPercentageString()
                    }
                }
                
                
                Button {
                    //                LSXService.shared.popDetail()
                    showDeleteConfirmation = true
                    
                } label: {
                    HStack(spacing: 24) {
                        Text("Delete Account")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Image(systemName: "trash")
                    }
                    .foregroundStyle(Color.red)
                }
                .buttonStyle(MenuButtonStyle())
                
                
                
                
//                Button(action: continueTapped) {
//                    Text("Continue")
//                        .frame(maxWidth: .infinity)
//                }
//                .buttonStyle(ThemeButtonStyle())
                
            } //: VStack
            //            .navigationTitle("Company info")
            //            .navigationBarTitleDisplayMode(.large)
            .frame(maxWidth: 720)
            .padding()
            .onTapGesture {
                self.focus = nil
            }
        } //: Scroll
        .navigationTitle("Account")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .scrollIndicators(.hidden)
        .background(Color.bg.ignoresSafeArea())
        .onAppear {
            print("Found \(companies.count) companies")
            if let company = companies.first {
                self.company = company
                self.companyName = company.name
                if company.taxRate > 0 {
                    self.taxRate = company.formattedTaxRate
                }
            } else {
                self.company = CompanyEntity(name: "")
            }
        }
        .alert("Are you sure?", isPresented: $showDeleteConfirmation) {
            Button("Go back", role: .cancel) { }
            Button("Yes, delete account", role: .destructive) {
                //                LSXService.shared.primaryRoot = .makeASale
                //                LSXService.shared.detailRoot =  nil
                //                LSXService.shared.primaryPath = .init()
                //                LSXService.shared.detailPath = .init()
                
                Task {
                    await vm.deleteAccount()
                }
            }
        }
    } //: Body
    
}


#Preview {
    CompanyDetailView() {}
        .background(Color.bg)
}
