//
//  AddDepartmentView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/21/24.
//

import SwiftUI
import RealmSwift

@MainActor class DepartmentDetailViewModel: ObservableObject {
    @Published var errorMessage: String = ""
    
    func save(name: String, threshold: String, markup: String, completion: @escaping ((Error?) -> Void)) async {
        do {
            try await RealmActor().addDepartment(name: name, restockThresh: threshold, markup: markup)
            debugPrint("Successfully saved department.")
            completion(nil)
        } catch {
            errorMessage = error.localizedDescription
            print(error)
            completion(error)
        }
    }
    
    func deleteDepartment(withId id: RealmSwift.ObjectId, completion: @escaping ((Error?) -> Void)) async {
        do {
            try await RealmActor().deleteDepartment(id: id)
            debugPrint("Successfully deleted department")
            completion(nil)
        } catch {
            errorMessage = error.localizedDescription
            print(error.localizedDescription)
            completion(error)
        }
    }
    
    func update(department: DepartmentEntity, name: String, threshold: String, markup: String, completion: @escaping ((Error?) -> Void)) async {
        do {
            try await RealmActor().updateDepartment(dept: department, newName: name, thresh: threshold, markup: markup)
            print("Successfully updated department")
            completion(nil)
        } catch {
            errorMessage = error.localizedDescription
            print(error.localizedDescription)
            completion(error)
        }
    }
    
  
}

struct DepartmentDetailView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var vm: DepartmentDetailViewModel = DepartmentDetailViewModel()
    
    @State private var name: String = ""
    @State private var restockThreshold: String = ""
    @State private var markup: String = ""
    
    let department: DepartmentEntity
    
    /// Used to hide the back button and title while onboarding.
    @State var showTitles: Bool
    
    /// Used in onboarding view to execute additional logic.
    let onSuccess: (() -> Void)?
    
    let detailType: DetailViewType
    
    
    private enum Focus { case name, threshold, markup }
    @FocusState private var focus: Focus?
    
    init(department: DepartmentEntity, showTitles: Bool = true, onSuccess: (() -> Void)? = nil) {
        self.department = department
        self.showTitles = showTitles
        self.onSuccess = onSuccess
        self.detailType = department.name.isEmpty ? .create : .modify
    }
    
    // TODO: Move logic into VM.
    /// When the view is initialized, `detailType` is determined by whether a department was passed to the view or not. If it was, the department exists and should be modified otherwise the user is adding a department
    private func continueTapped() {
        focus = nil
        Task {
            if detailType == .modify {
                await vm.update(department: department, name: name, threshold: restockThreshold, markup: markup) { error in
                    guard error == nil else { return }
                    finish()
                }
            } else {
                await vm.save(name: name, threshold: restockThreshold, markup: markup, completion: { error in
                    guard error == nil else { return }
                    finish()
                })
            }
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
                        
                        Text(detailType == .modify ? "Edit department" : "Add department")
                        
                    } //: VStack
                    .modifier(TitleMod())
                    .frame(maxWidth: 720)
                }
                

                // MARK: - FORM FIELDS
                VStack(alignment: .leading, spacing: 24) {
                    ThemeTextField(boundTo: $name,
                                   placeholder: "i.e. Clothing",
                                   title: "Department Name:",
                                   subtitle: nil,
                                   type: .text)
                    .focused($focus, equals: .name)
                    
                    ThemeTextField(boundTo: $restockThreshold,
                                   placeholder: "0",
                                   title: "Restock Threshold:",
                                   subtitle: "This will help you quickly find items that need to be restocked.",
                                   type: .integer)
                    .keyboardType(.numberPad)
                    .focused($focus, equals: .threshold)
                    
                    ThemeTextField(boundTo: $markup,
                                   placeholder: "0",
                                   title: "Default markup:",
                                   subtitle: "When an item is added to this department it will be marked up by this percentage by default.",
                                   type: .percentage)
                    .keyboardType(.numberPad)
                    .focused($focus, equals: .markup)
                } //: VStack
                .padding(.vertical, 24)
                .onChange(of: focus) { _, newValue in
                    guard !markup.isEmpty else { return }
                    guard let markup = Double(markup) else { return }
                    self.markup = markup.toPercentageString()
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
            .onAppear {
                name = department.name
                if department.restockNumber != 0 {
                    restockThreshold = String(describing: department.restockNumber)
                }
                
                if department.defMarkup != 0 {
                    markup = String(describing: department.defMarkup)
                }
            }
        } //: ScrollView
        .overlay(detailType == .modify ? deleteButton : nil, alignment: .topTrailing)
        
    } //: Body
    
    @State var showRemoveItemsAlert: Bool = false
    @State var showDeleteConfirmation: Bool = false
    
    private var deleteButton: some View {
        Menu {
            Button("Delete department", systemImage: "trash", role: .destructive) {
                if !department.items.isEmpty {
                    showRemoveItemsAlert = true
                } else {
                    
                }
            }
        } label: {
            Image(systemName: "ellipsis.circle")
        }
        .font(.title)
        .padding()
        .foregroundStyle(.primary)
        .alert("You must remove the items from this department before you can delete it.", isPresented: $showRemoveItemsAlert) {
            Button("Okay", role: .cancel) { }
        }
        .alert("Are you sure you want to delete this department? This can't be done.", isPresented: $showRemoveItemsAlert) {
            Button("Go back", role: .cancel) { }
            Button("Yes, delete Item", role: .destructive) {
                Task {
                    await vm.deleteDepartment(withId: department._id) { error in
                        guard error == nil else { return }
                        dismiss()
                    }
                }
            }
        }
    } //: Delete Button
    
}

#Preview {
    DepartmentDetailView(department: DepartmentEntity())
}



