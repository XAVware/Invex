//
//  InventoryListView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 4/9/24.
//

import SwiftUI
import RealmSwift


@MainActor class InventoryListViewModel: ObservableObject {
    @ObservedResults(DepartmentEntity.self) var departments
    
    @Published var errorMessage = ""
    
    func deleteDepartment(withId id: RealmSwift.ObjectId) async {
        do {
            try await RealmActor().deleteDepartment(id: id)
            debugPrint("Successfully deleted department")
        } catch {
            errorMessage = error.localizedDescription
            print(error.localizedDescription)
        }
    }

}



struct InventoryListView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @ObservedResults(ItemEntity.self) var items
//    @Environment(\.layoutDirection) private var layoutDirection
    @StateObject var vm = InventoryListViewModel()
    private var isCompact: Bool { horizontalSizeClass == .compact }
    
    @State var showDepartmentDetail: Bool = false
//    @State var showItemDetail: Bool = false
    @State var showMoveItems: Bool = false
    
    // For when a user taps edit department.
    @State var editingDepartment: DepartmentEntity?
    
    // Department filter
    @State var selectedDepartment: DepartmentEntity?
    @State var selectedItem: ItemEntity?
    
    @State var showRemoveItemsAlert: Bool = false
    @State var showDeleteConfirmation: Bool = false
    
    /// Used for small screens
    @State var columnData: [ColumnHeaderModel] = [
        ColumnHeaderModel(headerText: "Item", sortDescriptor: ""),
        ColumnHeaderModel(headerText: "Stock", sortDescriptor: ""),
        ColumnHeaderModel(headerText: "Price", sortDescriptor: ""),
        ColumnHeaderModel(headerText: "Cost", sortDescriptor: "")
    ]
    
    let uiProperties: LayoutProperties
    
    var body: some View {
        VStack {
            if horizontalSizeClass == .regular {
                regularView
            } else {
                compactView
            }
        }
        .sheet(item: $selectedItem, onDismiss: {
            vm.departments.realm?.refresh()
        }) { item in
            AddItemView(item: item)
        }
        .sheet(item: $editingDepartment, onDismiss: {
            selectedDepartment = vm.departments.first
        }) { dept in
            DepartmentDetailView(department: dept)
        }
        .sheet(isPresented: $showMoveItems, content: {
            MoveItemsView(fromDepartment: self.selectedDepartment)
        })
        
    } //: Body
    
    func itemTapped(_ item: ItemEntity) {
        do {
            let item = try RealmActor().fetchItem(withId: item._id)
            self.selectedItem = item
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getItems() -> Array<ItemEntity>{
        if let dept = selectedDepartment {
            return Array(dept.items)
        } else {
            Task {
                do {
                    let items = try RealmActor().fetchAllItems()
                    return Array(items)
                } catch {
                    print(error.localizedDescription)
                    return Array()
                }
            }
            return Array()
        }
    }
    
    
    // TODO: May need to change view to use ResponsiveView and LayoutProperties instead of size class because I'm not using built in navigation.
    @ViewBuilder private var regularView: some View {
        VStack {
            // MARK: - TOOLBAR
            HStack {
                HStack {
                    Image(systemName: "shippingbox")
                    Text("Inventory")
                        .font(.title)
                }
                
                Spacer()
                
                if uiProperties.landscape == false {
                    DepartmentPicker(selectedDepartment: $selectedDepartment, style: .dropdown)
                        .frame(height: 34)
                }

                Button("Department", systemImage: "plus") { 
                    editingDepartment = DepartmentEntity()
                }
                .buttonStyle(BorderedButtonStyle())
                
                Button("Item", systemImage: "plus") {
                    selectedItem = ItemEntity()
                }
                .buttonStyle(BorderedButtonStyle())

            } //: HStack
            
            HStack(spacing: 16) {
                // MARK: - DEPARTMENT LIST PANE
                if uiProperties.landscape {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "building.2.fill")
                            Text("Departments")
                                .font(.subheadline)
                            Spacer()
                        } //: HStack
                        
                        ScrollView {
                            ForEach(vm.departments) { dept in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(selectedDepartment == dept ? .accent.opacity(0.75) : .clear)
                                    HStack {
                                        Text(dept.name)
                                        Spacer()
                                        
                                        Image(systemName: selectedDepartment == dept ? "circle.fill" : "circle")
                                    } //: HStack
                                    .foregroundStyle(selectedDepartment == dept ? .white : .black)
                                    .padding(8)
                                    .onTapGesture {
                                        selectedDepartment = dept
                                    }
                                } //: ZStack
                            } //: ForEach
                            
                            
                        } //: Scroll
                    } //: VStack
                    .frame(minWidth: 120, idealWidth: 160, maxWidth: 220, maxHeight: .infinity)
                    .onAppear {
                        guard let dept = vm.departments.first, !isCompact else { return }
                        selectedDepartment = dept
                    }
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    // MARK: - DEPARTMENT HIGHLIGHT PANE
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
                        
                        TableColumn("Name") { item in
                            Text(item.name)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .onTapGesture { itemTapped(item) }
                        }
                        
                        TableColumn("Attribute") { item in
                            Text(item.attribute)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .onTapGesture { itemTapped(item) }
                        }
                        
                        TableColumn("Stock") { item in
                            Text(item.formattedQty)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .onTapGesture { itemTapped(item) }
                        }
                        .width(min: 96)
                        
                        TableColumn("Price") { item in
                            Text(item.formattedPrice)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .onTapGesture { itemTapped(item) }
                        }
                        .width(max: 96)
                        
                        TableColumn("Cost") { item in
                            Text(item.formattedUnitCost)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .onTapGesture { itemTapped(item) }
                        }
                        .width(max: 96)
                        
                        TableColumn("") { item in
                            Text(item.restockWarning)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .onTapGesture { itemTapped(item) }
                        }
                        .width(24)
                    } rows: {
                        if showMoveItems == false {
                            if let selectedDepartment = selectedDepartment {
                                ForEach(selectedDepartment.items) {
                                    TableRow($0)
                                }
                            } else {
                                TableRow(ItemEntity())
                            }
                        }
                    }
                    .padding(.vertical, 6)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.gray.opacity(0.7), lineWidth: 0.5)
                    )
                    
                    .frame(maxWidth: .infinity)
                } //: VStack
            } //: HStack
        } //: VStack
        .padding()
        .background(Color("Purple050").opacity(0.2))
    }
    
    @ViewBuilder private var compactView: some View {
        VStack {
            // MARK: - TOOLBAR
            HStack {
                HStack {
                    Image(systemName: "shippingbox")
                    Text("Inventory")
                        .font(.title)
                }
                
                Spacer()

                Button("Department", systemImage: "plus") {
                    editingDepartment = DepartmentEntity()
                }
                .buttonStyle(BorderedButtonStyle())
                
                Button("Item", systemImage: "plus") {
                    selectedItem = ItemEntity()
                }
                .buttonStyle(BorderedButtonStyle())

            } //: HStack
            HStack {
                ForEach(columnData) { header in
                    Text(header.headerText)
                        .font(.callout)
                        .fontDesign(.rounded)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                Spacer().frame(width: 24)
                
            } //: HStack
            .padding(8)
            
            ScrollView {
                VStack {
                    
                    ForEach(items) { item in
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(item.name)
                                        .fontWeight(.semibold)
                                    
                                    Text(item.attribute)
                                        .fontWeight(.light)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                } //: VStack
                                
                                Text(item.formattedQty)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text(item.formattedPrice)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text(item.formattedUnitCost)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text("⚠️")
                            } //: HStack
                            .frame(height: 64) 
                        Divider()
                    }
                    .scrollIndicators(.hidden)
                    Spacer()
                } //: VStack
//                .padding()
            } //: ScrollView
//            .modifier(TableStyleMod())
            .padding(8)
            .navigationDestination(for: ItemEntity.self, destination: { item in
                AddItemView(item: item, showTitles: false)
            })
            .sheet(isPresented: $showDepartmentDetail, content: {
                DepartmentDetailView(department: DepartmentEntity())
            })
            
        } //: VStack
        .padding()
    } //: Compact View
    
    @ViewBuilder private var departmentMenu: some View {
        if let dept = selectedDepartment {
            Menu {
                Button("Edit department", systemImage: "pencil") {
//                    showDepartmentDetail = true
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
    
    
    struct PaneOutlineMod: ViewModifier {
        func body(content: Content) -> some View {
            content
                .padding(.horizontal)
                .padding(.vertical, 8)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(.gray.opacity(0.7), lineWidth: 0.5)
                )
                .background(.white)
        }
    }

}

#Preview {
    ResponsiveView { props in
        InventoryListView(uiProperties: props)
            .environment(\.realm, DepartmentEntity.previewRealm)
    }
}
