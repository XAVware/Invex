//
//  InventoryListView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 4/9/24.
//

import SwiftUI
import RealmSwift


@MainActor class InventoryListViewModel: ObservableObject {
//    private let realmActor: RealmActor = RealmActor()
//    @Published var selectedDepartment: DepartmentEntity?

//    func addDepartment() async {
//        do {
////            try await RealmActor().addDepartment(name: "Test", restockThresh: 10, markup: 0.5)
//            print("Department added")
//        } catch {
//            print(error)
//        }
//    }
    
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
    @ObservedResults(DepartmentEntity.self) var departments
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @StateObject var vm = InventoryListViewModel()
    private var isCompact: Bool { horizontalSizeClass == .compact }
    
    @State var showDepartmentDetail: Bool = false
    @State var showItemDetail: Bool = false
    @State var showMoveItems: Bool = false
    
    @State var editingDepartment: DepartmentEntity?
    
    @State var selectedDepartment: DepartmentEntity?
    @State var selectedItem: ItemEntity?
    
    @State var showRemoveItemsAlert: Bool = false
    @State var showDeleteConfirmation: Bool = false
    
    /// Used for small screens
    @State var columnData: [ColumnHeaderModel] = [
        ColumnHeaderModel(headerText: "Item", sortDescriptor: ""),
        //        ColumnHeaderModel(headerText: "Dept.", sortDescriptor: ""),
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
        .sheet(item: $selectedItem) { item in
            AddItemView(item: item)
        }
        .sheet(item: $editingDepartment, onDismiss: {
            selectedDepartment = departments.first
        }) { dept in
            DepartmentDetailView(department: dept)
        }
    } //: Body
    
    func itemTapped(_ item: ItemEntity) {
        do {
            let item = try RealmActor().fetchItem(withId: item._id)
            self.selectedItem = item
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @ViewBuilder private var regularView: some View {
        VStack {
            HStack {
                Text("Inventory")
                    .font(.title)
                
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
            
            HStack(spacing: 16) {
                VStack(alignment: .leading) {
                    Text("Departments")
                        .font(.headline)
                    
                    ScrollView {
                        ForEach(departments) { dept in
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
                            }
                        }
                        
                        
                    } //: Scroll
                } //: VStack
                .padding(8)
                .background(.white)
                .frame(minWidth: 180, idealWidth: 220, maxWidth: 240, maxHeight: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.gray.opacity(0.7), lineWidth: 0.5)
                )
                .onAppear {
                    guard let dept = departments.first, !isCompact else { return }
                    selectedDepartment = dept
                }
                
                VStack(alignment: .leading, spacing: 16) {
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
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.gray.opacity(0.7), lineWidth: 0.5)
                    )
                    
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
                        .width(min: 96)
                        
                        TableColumn("Cost") { item in
                            Text(item.formattedUnitCost)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .onTapGesture { itemTapped(item) }
                        }
                        .width(min: 96)
                        
                        TableColumn("") { item in
                            Text(item.restockWarning)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .onTapGesture { itemTapped(item) }
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
                    .padding(.vertical, 6)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.gray.opacity(0.7), lineWidth: 0.5)
                    )
                    
                } //: VStack
            } //: HStack
        } //: VStack
        .padding()
        .background(Color("Purple050").opacity(0.2))
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
    
    @ViewBuilder private var compactView: some View {
//        if let selectedDepartment = selectedDepartment {
            // Headers for compact size class
            HStack {
                ForEach(columnData) { header in
                    Text(header.headerText)
                        .font(.callout)
                        .fontDesign(.rounded)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                Spacer().frame(width: 24)
                
            } //: HStack
            .padding()
            
            ScrollView {
                VStack {
                    
                    ForEach(getItems()) { item in
                        NavigationLink(value: item) {
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(item.name)
                                        .fontWeight(.semibold)
                                    
                                    Text(item.attribute)
                                        .fontWeight(.light)
                                        .frame(maxWidth: .infinity)
                                } //: VStack
                                
                                Text(item.formattedQty)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text(item.formattedPrice)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text(item.formattedUnitCost)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text("⚠️")
                            } //: HStack
                            .padding()
                        }
                        
                    }
                    .scrollIndicators(.hidden)
                    Spacer()
                } //: VStack
                .padding()
            } //: ScrollView
            .modifier(TableStyleMod())
            .padding()
//            .navigationTitle(selectedDepartment.name)
            .navigationDestination(for: ItemEntity.self, destination: { item in
                AddItemView(item: item, showTitles: false)
            })
            .sheet(isPresented: $showDepartmentDetail, content: {
                DepartmentDetailView(department: DepartmentEntity())
            })
            
            
//        } //: Scroll
        
    }
    
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
                        await vm.deleteDepartment(withId: dept._id)
                        selectedDepartment = departments.first
                    }
                }
            }
        }
    } //: Delete Button
    
}

#Preview {
    ResponsiveView { props in
        InventoryListView(uiProperties: props)
            .environment(\.realm, DepartmentEntity.previewRealm)
    }
}
