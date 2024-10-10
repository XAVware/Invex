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
        var id: TableType { return self}
    }
    
    private func addButtonTapped() {
        let navItem: LSXDisplay = tableType == .items ? .item(nil, .create) : .department(nil, .create)
        navService.path.append(navItem)
    }
    
    var body: some View {
        
        VStack(spacing: 16) {
            Picker("Table Type", selection: $tableType) {
                ForEach(TableType.allCases) { type in
                    Text(type.rawValue.capitalized)
                }
            }
            .pickerStyle(.segmented)
            
            
            ZStack(alignment: .center) {
                Color.bg.ignoresSafeArea()
                NeomorphicCardView(layer: .under)
                if tableType == .items {
                    ItemTableView(items: self.$items)
                } else {
                    DepartmentTableView(depts: self.$departments)
                }
            } //: ZStack
        } //: VStack
        .navigationTitle(tableType == .items ? "Item List" : "Departments")
        .overlay(addButton, alignment: .bottomTrailing)
        .padding(.bottom)
//        .padding(.horizontal, hSize == .regular ? 12 : 4)
        .background(.clear)
    } //: Body
    
    private var addButton: some View {
        Button(action: addButtonTapped) {
            HStack {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
//                    .fontWeight(.bold)
                
                if hSize == .regular {
                    Text("New Item")
//                        .padding(6)
                }
            }
            .padding(6)
//            .frame(maxHeight: 28)
            .font(.headline)
//            .fontWeight(.semibold)
//            .fontDesign(.rounded)
        }
        .buttonStyle(ThemeButtonStyle())
//        .frame(maxWidth: 320)
        .padding()
        .cornerRadius(48)
    }
    
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
