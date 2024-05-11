//
//  NewInventoryListView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 4/21/24.
//

import SwiftUI
import RealmSwift

struct NewInventoryListView: View {
//    @State var colVis: NavigationSplitViewVisibility = .detailOnly
//    @Binding var currentDisplay: NewDisplayState
//    @State var prefCompactCol: NavigationSplitViewColumn = .detail
    
    @ObservedResults(DepartmentEntity.self) var departments
    @StateObject var invListVM = InventoryListViewModel()
//    @State var selectedItem: ItemEntity?
    
    @State var showRemoveItemsAlert: Bool = false
    @State var showDeleteConfirmation: Bool = false
    
    @State var showDepartmentDetail: Bool = false
//    @State var showItemDetail: Bool = false
    @State var showMoveItems: Bool = false
    
    // For when a user taps edit department.
    @State var editingDepartment: DepartmentEntity?
    
    // Department filter
    @State var selectedDepartment: DepartmentEntity?
    @State var selectedItem: ItemEntity?
    
    var body: some View {

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
                
                // MARK: - REGULAR SIZE TABLE
                Table(of: ItemEntity.self) {
                    TableColumn("Name", value: \.name)
                    TableColumn("Attribute", value: \.attribute)
                    TableColumn("Stock", value: \.formattedQty)
                        .width(min: 96)
                    TableColumn("Price", value: \.formattedPrice)
                        .width(max: 96)
                    TableColumn("Cost", value: \.formattedUnitCost)
                        .width(max: 96)
                    TableColumn("", value: \.restockWarning)
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
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("GrayTextColor").opacity(0.4), lineWidth: 0.5)
                )
            } //: VStack
            .padding()
            .background(Color("bgColor"))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Filters", systemImage: "slider.vertical.3") {
                        
                    }
                } //: Toolbar Item - Filters Button
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Department", systemImage: "plus") {
                        editingDepartment = DepartmentEntity()
                    }
                    .buttonStyle(BorderedButtonStyle())
                    
                    Button("Item", systemImage: "plus") {
                        selectedItem = ItemEntity()
                    }
                    .buttonStyle(BorderedButtonStyle())
                }
            }
        
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

//#Preview {
//    NewInventoryListView()
//}


#Preview {
    ResponsiveView { props in
        NewRootView(uiProperties: props, cartState: CartState.sidebar)
            .environment(\.realm, DepartmentEntity.previewRealm)
            .environmentObject(PointOfSaleViewModel())
    }
}
