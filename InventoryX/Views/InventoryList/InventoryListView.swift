//
//  InventoryListView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 4/9/24.
//

import SwiftUI
import RealmSwift


struct InventoryListView: View {
    @Environment(NavigationService.self) var navService
    @Environment(\.horizontalSizeClass) var hSize
    
    @ObservedResults(ItemEntity.self) var items
    @ObservedResults(DepartmentEntity.self) var departments
    @StateObject var vm = InventoryListViewModel()
    
    @State var showMoveItems: Bool = false
    
    // For when a user taps edit department.
    @State var editingDepartment: DepartmentEntity?
    
    // Department filter
    @State var selectedDepartment: DepartmentEntity?
    
    @State var showRemoveItemsAlert: Bool = false
    @State var showDeleteConfirmation: Bool = false
    @State var tableType: TableType = .items
    
    enum TableType: String, CaseIterable, Identifiable {
        case items
        case department
        var id: TableType { return self }
    }
    
    private func addButtonTapped() {
        let navItem: LSXDisplay = tableType == .items ? .item(nil, .create) : .department(nil, .create)
        navService.path.append(navItem)
    }
    
    private func editDepartmentTapped() {
        editingDepartment = selectedDepartment
    }
    
    private func moveItemsTapped() {
        showMoveItems = true
    }
    
    private func deleteDepartmentTapped() {
        if let dept = selectedDepartment {
            if !dept.items.isEmpty {
                showRemoveItemsAlert = true
            } else {
                showDeleteConfirmation = true
            }
        }
    }
    
    var body: some View {
        VStack {
            Picker("Table Type", selection: $tableType) {
                ForEach(TableType.allCases) { type in
                    Text(type.rawValue.capitalized)
                }
            }
            .pickerStyle(.segmented)
            .frame(maxWidth: 320)
            
            Group {
                switch tableType {
                case .items:
                    ItemTableView(items: self.$items)
                        .navigationTitle("Items")
                    
                case .department:
                    DepartmentTableView(depts: self.$departments)
                        .navigationTitle("Departments")
                    
                }
            }
//            .overlay(addButton, alignment: .bottomTrailing)
            .modifier(RoundedOutlineMod(cornerRadius: 6))
            .padding()
        } //: VStack
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add", systemImage: "plus", action: addButtonTapped)
//                Button(action: addButtonTapped) {
//                    HStack {
//                        Image(systemName: "plus")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 18, height: 18)
//                        
//                        if hSize == .regular {
//                            Text("New Item")
//                        }
//                    }
//                    .padding(6)
//                    .font(.headline)
//                }
//                .buttonStyle(ThemeButtonStyle())
//                .padding()
//                .cornerRadius(48)
            }
        }
    } //: Body
    
    @ViewBuilder private var departmentMenu: some View {
        if let dept = selectedDepartment {
            Menu {
                Button("Edit department", systemImage: "pencil", action: editDepartmentTapped)
                Button("Move items", action: moveItemsTapped)
                Button("Delete department", systemImage: "trash", role: .destructive, action: deleteDepartmentTapped)
            } label: {
                Image(systemName: "ellipsis.circle")
            }
            .alert("You must remove the items from this department before you can delete it.", isPresented: $showRemoveItemsAlert) {
                Button("Okay", role: .cancel) { }
            }
            .alert("Are you sure you want to delete this department? This can't be undone.", isPresented: $showDeleteConfirmation) {
                Button("Go back", role: .cancel) { }
                Button("Yes, delete department", role: .destructive) {
                    guard let dept = selectedDepartment else { return }
                    Task {
                        await vm.deleteDepartment(withId: dept._id)
                        selectedDepartment = vm.departments.first
                    }
                }
            }
        }
    } //: Delete Button
    
}

#Preview {
    InventoryListView()
        .environment(\.realm, DepartmentEntity.previewRealm)
        .environment(NavigationService())
}
