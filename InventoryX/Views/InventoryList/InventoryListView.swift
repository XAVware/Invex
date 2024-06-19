//
//  InventoryListView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 4/9/24.
//

import SwiftUI
import RealmSwift


struct InventoryListView: View {
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
    @State var selectedTableType: TableType = .items
    
    enum TableType: String, CaseIterable, Identifiable {
        case items
        case department
        var id: TableType { return self}
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack {
                HStack {
                    Picker("Table Type", selection: $selectedTableType) {
                        ForEach(TableType.allCases) { type in
                            Text(type.rawValue.capitalized)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    Spacer()
                    
                    Button("Add", systemImage: "plus") {
                        if selectedTableType == .items {
                            LazySplitService.shared.pushPrimary(.item(nil, .create))
                        } else {
                            LazySplitService.shared.pushPrimary(.department(nil, .create))
                        }
                    }
                }
                
                Divider()
            } //: VStack
            .padding(.horizontal)
            .padding(.vertical, 8)
            
            if selectedTableType == .items {
                ItemTableView(items: self.$items)
            } else {
                DepartmentTableView(depts: self.$departments)
            }
        } //: VStack
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color("GrayTextColor").opacity(0.4), lineWidth: 0.5)
        )
        .navigationTitle(selectedTableType == .items ? "Inventory" : "Departments")
        .padding()
        
    } //: Body
    
    @ViewBuilder private var departmentMenu: some View {
        if let dept = selectedDepartment {
            Menu {
                Button("Edit department", systemImage: "pencil") {
                    editingDepartment = selectedDepartment
                }
                
                Button("Move items") {
                    showMoveItems = true
                }
                
                Button("Delete department", systemImage: "trash", role: .destructive) {
                    if !dept.items.isEmpty {
                        showRemoveItemsAlert = true
                    } else {
                        showDeleteConfirmation = true
                    }
                }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
            .alert("You must remove the items from this department before you can delete it.", isPresented: $showRemoveItemsAlert) {
                Button("Okay", role: .cancel) { }
            }
            .alert("Are you sure you want to delete this department? This can't be done.", isPresented: $showDeleteConfirmation) {
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
    NavigationStack {
        InventoryListView()
            .environment(\.realm, DepartmentEntity.previewRealm)
    }
}
