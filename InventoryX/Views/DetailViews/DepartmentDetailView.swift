//
//  AddDepartmentView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/21/24.
//

import SwiftUI
import RealmSwift

enum DetailViewType { case create, modify }

struct DepartmentDetailView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var vm: DetailViewModel = DetailViewModel()
    @State private var name: String = ""
    @State private var restockThreshold: String = ""
    @State private var markup: String = ""
    
    let department: DepartmentEntity?
    
    /// Used in onboarding view to execute additional logic.
    let onSuccess: (() -> Void)?
    
    let detailType: DetailType
    
    @State var showRemoveItemsAlert: Bool = false
    @State var showDeleteConfirmation: Bool = false
    private enum Focus { case name, threshold, markup }
    @FocusState private var focus: Focus?
    
    init(department: DepartmentEntity?, detailType: DetailType, onSuccess: (() -> Void)? = nil) {
        self.department = department
        self.detailType = detailType
        self.onSuccess = onSuccess
    }
    
    // TODO: Move logic into VM.
    private func continueTapped() {
        focus = nil
        Task {
            if let department = department, detailType == .update {
                await vm.update(department: department, name: name, threshold: restockThreshold, markup: markup) { error in
                    guard error == nil else { return }
                    
                    if let onSuccess = onSuccess {
                        onSuccess()
                    } else {
                        dismiss()
                    }
                }
            } else {
                await vm.save(name: name, threshold: restockThreshold, markup: markup) { error in
                    guard error == nil else { return }
                    if let onSuccess = onSuccess {
                        onSuccess()
                    } else {
                        dismiss()
                    }
                    
                }
            }
            
        }
        
    }
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text(vm.errorMessage)
                    .foregroundStyle(.red)
                
                
                VStack(alignment: .leading) {
                    ThemeTextField(boundTo: $name,
                                   placeholder: "i.e. Clothing",
                                   title: "Department Name:",
                                   hint: nil,
                                   type: .text)
                    .focused($focus, equals: .name)
                    .submitLabel(.return)
                    .onSubmit { focus = nil }
                    
                    FieldDivider()
                    
                    ThemeTextField(boundTo: $restockThreshold,
                                   placeholder: "0",
                                   title: "Restock Threshold:",
                                   hint: "This will help you quickly find items that need to be restocked.",
                                   type: .integer)
                    .keyboardType(.numberPad)
                    .focused($focus, equals: .threshold)
                    .submitLabel(.return)
                    .onSubmit { focus = nil }
                    
                    FieldDivider()
                    
                    ThemeTextField(boundTo: $markup,
                                   placeholder: "0",
                                   title: "Default markup:",
                                   hint: "When an item is added to this department it will be marked up by this percentage by default.",
                                   type: .percentage)
                    .keyboardType(.numberPad)
                    .focused($focus, equals: .markup)
                    .submitLabel(.return)
                    .onSubmit { focus = nil }
                } //: VStack
                .modifier(SectionMod())
                .onChange(of: focus) { _, newValue in
                    guard !markup.isEmpty else { return }
                    guard let markup = Double(markup) else { return }
                    self.markup = markup.toPercentageString()
                }
                
                Spacer()
                continueButton
                Spacer()
                
            } //: VStack
            .frame(maxWidth: 720)
            .padding()
            .onAppear {
                if let dept = department {
                    name = dept.name
                    if dept.restockNumber != 0 {
                        restockThreshold = String(describing: dept.restockNumber)
                    }
                    
                    if dept.defMarkup != 0 {
                        markup = String(describing: dept.defMarkup)
                    }
                }
            }
            .navigationTitle(detailType == .update ? "Edit department" : "Add department")
            .navigationBarTitleDisplayMode(.large)
        } //: Scroll
        .frame(maxWidth: .infinity, maxHeight: .infinity) 
        .scrollIndicators(.hidden)
        .background(Color.bg.ignoresSafeArea())
        .toolbar {
            if detailType == .update {
                deleteButton
            }
        }
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
    }
    
    
    private var deleteButton: some View {
        Menu {
            Button("Delete department", systemImage: "trash", role: .destructive) {
                guard let dept = department else { return }
                if !dept.items.isEmpty {
                    showRemoveItemsAlert = true
                } else {
                    
                }
            }
        } label: {
            Image(systemName: "ellipsis.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 22)
        }
        .foregroundStyle(.accent)
        .alert("You must remove the items from this department before you can delete it.", isPresented: $showRemoveItemsAlert) {
            Button("Okay", role: .cancel) { }
        }
        .alert("Are you sure you want to delete this department? This can't be done.", isPresented: $showRemoveItemsAlert) {
            Button("Go back", role: .cancel) { }
            Button("Yes, delete Item", role: .destructive) {
                if let dept = department {
                    Task {
                        await vm.deleteDepartment(withId: dept._id) { error in
                            guard error == nil else { return }
                            dismiss()
                        }
                    }
                }
            }
        }
    } //: Delete Button
    
}

#Preview {
    DepartmentDetailView(department: DepartmentEntity(), detailType: .create) {}
        .background(Color.bg) 
}



