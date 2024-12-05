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
//    @Environment(\.dismiss) var dismiss
//    @StateObject var vm: DetailViewModel = DetailViewModel()
//    @State private var name: String = ""
//    @State private var restockThreshold: String = ""
//    @State private var markup: String = ""
//    
//    let department: DepartmentEntity?
//    
//    /// Used in onboarding view to execute additional logic.
//    let onSuccess: (() -> Void)?
//    
//    let detailType: DetailType
//    
//    @State var showRemoveItemsAlert: Bool = false
//    @State var showDeleteConfirmation: Bool = false
//    private enum Focus { case name, threshold, markup }
//    @FocusState private var focus: Focus?
//    
//    init(department: DepartmentEntity?, detailType: DetailType, onSuccess: (() -> Void)? = nil) {
//        self.department = department
//        self.detailType = detailType
//        self.onSuccess = onSuccess
//    }
//    
//    // TODO: Move logic into VM.
//    private func continueTapped() {
//        focus = nil
//        Task {
//            if let department = department, detailType == .update {
//                await vm.update(department: department, name: name, threshold: restockThreshold, markup: markup) { error in
//                    guard error == nil else { return }
//                    
//                    if let onSuccess = onSuccess {
//                        onSuccess()
//                    } else {
//                        dismiss()
//                    }
//                }
//            } else {
//                await vm.save(name: name, threshold: restockThreshold, markup: markup) { error in
//                    guard error == nil else { return }
//                    if let onSuccess = onSuccess {
//                        onSuccess()
//                    } else {
//                        dismiss()
//                    }
//                    
//                }
//            }
//            
//        }
//        
//    }
//    
//    
//    var body: some View {
//        FormX(title: "Department", containers: []) {
//            ThemeFormSection(title: "General") {
//                    ThemeTextField(boundTo: $name, placeholder: "i.e. Clothing", title: "Department Name:", type: .text)
//                    .focused($focus, equals: .name)
//                    .submitLabel(.return)
//                    .onSubmit { focus = nil }
//                    
//                    FieldDivider()
//                    
//                    ThemeTextField(boundTo: $restockThreshold, placeholder: "0", title: "Restock Qty:",
//                                   hint: "This will help you quickly find items that need to be restocked.",
//                                   type: .integer)
//                    .keyboardType(.numberPad)
//                    .focused($focus, equals: .threshold)
//                    .submitLabel(.return)
//                    .onSubmit { focus = nil }
//                    
//                    FieldDivider()
//                    
//                    ThemeTextField(boundTo: $markup, placeholder: "0", title: "Default markup:",
//                                   hint: "When an item is added to this department it will be marked up by this percentage by default.",
//                                   type: .percentage)
//                    .keyboardType(.numberPad)
//                    .focused($focus, equals: .markup)
//                    .submitLabel(.return)
//                    .onSubmit { focus = nil }
//            } //: Theme Form Section
//            .onChange(of: focus) { _, newValue in
//                guard !markup.isEmpty else { return }
//                guard let markup = Double(markup) else { return }
////                self.markup = markup.toPercentageString()
//            }
//            
//        } //: VStack
//        .overlay(
//            Button(action: continueTapped) {
//                Text("Continue")
//                    .frame(maxWidth: .infinity)
//            }
//                .buttonStyle(ThemeButtonStyle())
//                .padding()
//            , alignment: .bottom)
////        .padding()
//        .onAppear {
//            if let dept = department {
//                name = dept.name
//                if dept.restockNumber != 0 {
//                    restockThreshold = String(describing: dept.restockNumber)
//                }
//                
//                if dept.defMarkup != 0 {
//                    markup = String(describing: dept.defMarkup)
//                }
//            }
//        }
//        .navigationTitle(detailType == .update ? "Edit department" : "Add department")
//        .navigationBarTitleDisplayMode(.large)
//        .toolbar {
//            if detailType == .update {
//                deleteMenu
//            }
//        }
//    } //: Body
    
    @Environment(\.dismiss) var dismiss
    @StateObject var vm: DetailViewModel = DetailViewModel()
    
    /// If the entity's name is empty when it is initially passed to the view, `isNew` is set to true
    let isNew: Bool
        
    @ObservedRealmObject var department: DepartmentEntity
    @State var showDeleteConfirmation: Bool = false
    
    init(department: DepartmentEntity) {
        self._department = ObservedRealmObject(wrappedValue: department)
        self.isNew = department.name.isEmpty
    }
    
    func createDefaultDepartment() {
        do {
            let realm = try Realm()
            let departments = realm.objects(DepartmentEntity.self)
            if departments.count == 0 && isNew {
                try realm.write {
                    realm.add(department)
                }
            }
        } catch {
            print("Error creating default company: \(error)")
        }
    }
    
    func validateDepartmentName(value: String) -> (Bool, String?) {
        if value.isEmpty {
            return (false, "Please enter a valid name.")
        } else {
            return (true, nil)
        }
    }
    
    func saveDepartmentName(validName: String) {
        do {
            let realm = try Realm()
            try realm.write {
                $department.wrappedValue.name = validName
            }
        } catch {
            print("Error saving name: \(error)")
        }
    }
    
    func saveRestockQuantity(validQty: Int) {
        do {
            let realm = try Realm()
            try realm.write {
                $department.wrappedValue.restockNumber = validQty
            }
        } catch {
            print("Error saving restock quantity: \(error)")
        }
    }
    
    func saveMarkup(validMarkup: Double) {
        do {
            let realm = try Realm()
            try realm.write {
                $department.wrappedValue.defMarkup = validMarkup
            }
        } catch {
            print("Error saving markup: \(error)")
        }
    }
    
//    func save() {
//        Task {
//            do {
//                let realm = try Realm()
//                try realm.write {
//                    $department
//                }
//            } catch {
//                print("Error saving markup: \(error)")
//            }
//        }
//    }
    
    let containerData: [ContainerXModel] = [
        ContainerXModel(title: "Department Name", description: "Your items will be grouped into departments."),
        ContainerXModel(title: "Restock Quantity", description: "When an item's stock is less than this number, you will be notified."),
        ContainerXModel(title: "Markup", description: "Automatically markup items in this department by this percentage.")
    ]
    
    var body: some View {
        FormX(title: "Department") {
            // Department Name Container
            ContainerX(data: containerData[0], value: department.name) {
                
                TextFieldX(value: department.name, validate: { value in
                    validateDepartmentName(value: value)
                }, save: { name in
                    Task {
                        saveDepartmentName(validName: name)
                    }
                })
                
            }
            
            DividerX()
            
            // Restock Quantity Container
            ContainerX(data: containerData[1], value: department.restockNumber.description) {
                NumberPickerX(number: department.restockNumber) { value in
                    saveRestockQuantity(validQty: value)
                }
            }
            
            DividerX()
            
            // Markup Container
            ContainerX(data: containerData[2], value: department.defMarkup.toPercentageString()) {
                PercentagePickerX(tax: department.defMarkup) { value in
                    Task {
                        saveMarkup(validMarkup: value)
                    }
                }
            }
            
        } //: FormX
        .onAppear {
            createDefaultDepartment()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if !isNew {
                    Menu {
                        Button("Delete Account", systemImage: "trash", role: .destructive) {
                            showDeleteConfirmation = true
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(Angle(degrees: 90))
                    }
                    .foregroundStyle(.accent)
                } else {
                    Spacer()
                }
            }
        }
        .alert("Are you sure?", isPresented: $showDeleteConfirmation) {
            Button("Go back", role: .cancel) { }
            Button("Yes, delete account", role: .destructive) {
                Task {
                    await vm.deleteAccount()
                }
            }
        }

        
    } //: Body
    
//    private var deleteMenu: some View {
//        Menu {
//            Button("Delete department", systemImage: "trash", role: .destructive) {
//                guard let dept = department else { return }
//                if !dept.items.isEmpty {
//                    showRemoveItemsAlert = true
//                } else {
//                    
//                }
//            }
//        } label: {
//            Image(systemName: "ellipsis.circle")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 22)
//        }
//        .foregroundStyle(.accent)
//        .alert("You must remove the items from this department before you can delete it.", isPresented: $showRemoveItemsAlert) {
//            Button("Okay", role: .cancel) { }
//        }
//        .alert("Are you sure you want to delete this department? This can't be done.", isPresented: $showRemoveItemsAlert) {
//            Button("Go back", role: .cancel) { }
//            Button("Yes, delete Item", role: .destructive) {
//                if let dept = department {
//                    Task {
//                        await vm.deleteDepartment(withId: dept._id) { error in
//                            guard error == nil else { return }
//                            dismiss()
//                        }
//                    }
//                }
//            }
//        }
//    } //: Delete Button
    
}

#Preview {
    DepartmentDetailView(department: DepartmentEntity())
        .background(Color.bg)
}

struct DividerX: View {
    @Environment(FormXViewModel.self) var formVM
    
    var body: some View {
        if formVM.expandedContainer == nil {
            Divider()
        }
    }
}

