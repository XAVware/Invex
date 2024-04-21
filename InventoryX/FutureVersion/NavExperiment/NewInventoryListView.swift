//
//  NewInventoryListView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 4/21/24.
//

import SwiftUI
import RealmSwift

struct NewInventoryListView: View {
    @ObservedResults(DepartmentEntity.self) var departments
    @StateObject var invListVM = InventoryListViewModel()
    @State var selectedDepartment: DepartmentEntity?
    @State var selectedItem: ItemEntity?
    
    @State var showRemoveItemsAlert: Bool = false
    @State var showDeleteConfirmation: Bool = false
    
    @State var showDepartmentDetail: Bool = false
    @State var showItemDetail: Bool = false
    @State var showMoveItems: Bool = false
    
    var body: some View {
        // MARK: - INVENTORY VIEW
        VStack(alignment: .leading, spacing: 16) {
            // DEPARTMENT HIGHLIGHT PANE
            HStack {
                VStack(alignment: .leading) {
                    Text("\(selectedDepartment?.name ?? "") Dept.")
                        .font(.headline)
                    
                    Text("\(selectedDepartment?.items.count ?? 0) Items")
                        .font(.callout)
                } //: VStack
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Markup")
                        .font(.headline)
                    Text(selectedDepartment?.defMarkup.toPercentageString() ?? "0%")
                        .font(.callout)
                } //: VStack
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Restock")
                        .font(.headline)
                    Text(selectedDepartment?.defMarkup.toPercentageString() ?? "0")
                        .font(.callout)
                } //: VStack
                
                Spacer()
                
                departmentMenu
                    .font(.title2)
            } //: HStack
            .modifier(PaneOutlineMod())
            
//                        GeometryReader { geo in
                // MARK: - REGULAR SIZE TABLE
                Table(of: ItemEntity.self) {
                    
                    TableColumn("Name") { item in
                        Text(item.name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    TableColumn("Attribute") { item in
                        Text(item.attribute)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    TableColumn("Stock") { item in
                        Text(item.formattedQty)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .width(min: 96)
                    
                    TableColumn("Price") { item in
                        Text(item.formattedPrice)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .width(max: 96)
                    
                    TableColumn("Cost") { item in
                        Text(item.formattedUnitCost)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .width(max: 96)
                    
                    TableColumn("") { item in
                        Text(item.restockWarning)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .width(24)
                } rows: {
                    if let selectedDepartment = selectedDepartment {
                        ForEach(selectedDepartment.items) {
                            TableRow($0)
                        }
                    } else {
                        TableRow(ItemEntity())
                    }
                }
                //                    .padding(.vertical, 6)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.gray.opacity(0.7), lineWidth: 0.5)
                )
//                        } //: Geometry Reader
        } //: VStack
        .padding()
        .background(Color("Purple050").opacity(0.2))
        .navigationTitle("Inventory")
        .navigationSplitViewColumnWidth(400)
        
    } //: Body
    
    @ViewBuilder private var departmentMenu: some View {
        if let dept = selectedDepartment {
            Menu {
                Button("Edit department", systemImage: "pencil") {
                    showDepartmentDetail = true
                }
                
                Button("Move items") {
                    
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
                Button("Yes, delete Item", role: .destructive) {
                    guard let dept = selectedDepartment else { return }
                    Task {
                        await invListVM.deleteDepartment(withId: dept._id)
                        selectedDepartment = departments.first
                    }
                }
            }
        }
    } //: Delete Button
}

#Preview {
    NewInventoryListView()
}
