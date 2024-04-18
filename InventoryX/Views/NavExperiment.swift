//
//  NavExperiment.swift
//  InventoryX
//
//  Created by Ryan Smetana on 4/18/24.
//

import SwiftUI
import RealmSwift

struct NavExperiment: View {
    @State var colVis: NavigationSplitViewVisibility = .doubleColumn
    @State var prefCompactCol: NavigationSplitViewColumn = .detail
    
    
    @ObservedResults(DepartmentEntity.self) var departments
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.layoutDirection) private var layoutDirection
    @StateObject var vm = InventoryListViewModel()
    private var isCompact: Bool { horizontalSizeClass == .compact }
    
    @State var showDepartmentDetail: Bool = false
    @State var showItemDetail: Bool = false
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
        //        ColumnHeaderModel(headerText: "Dept.", sortDescriptor: ""),
        ColumnHeaderModel(headerText: "Stock", sortDescriptor: ""),
        ColumnHeaderModel(headerText: "Price", sortDescriptor: ""),
        ColumnHeaderModel(headerText: "Cost", sortDescriptor: "")
    ]
    
    let uiProperties: LayoutProperties
    
    var body: some View {
        NavigationSplitView(columnVisibility: $colVis, preferredCompactColumn: $prefCompactCol) {
            menu
                .navigationSplitViewColumnWidth(280)
        } content: {
            VStack {
                Menu {
                    ForEach(departments) { dept in
                        Button {
                            selectedDepartment = dept
                        } label: {
                            Text(dept.name)
                        }
                    }
                } label: {
                    Text("Department:")
                        .font(.caption)
                    
                    Spacer()
                    
                    Text("Select")
                        .font(.caption2)
                }
                .padding(.horizontal)
                .frame(minWidth: 180, maxWidth: 280, minHeight: 32, idealHeight: 36, maxHeight: 40)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
                .shadow(radius: 1)

                
                Spacer()
            } //: VStack
            .padding([.vertical, .leading])
            .padding(.trailing, 2)
            .background(Color("Purple050").opacity(0.2))
//            .navigationTitle("Filters")
            .navigationSplitViewColumnWidth(min: 180, ideal: 240, max: 280)
            .onAppear {
                guard let dept = departments.first, !isCompact else { return }
                selectedDepartment = dept
            }
            
            

        } detail: {
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
                
                GeometryReader { geo in
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
                } //: Geometry Reader
            } //: VStack
            .padding()
            .background(Color("Purple050").opacity(0.2))
            .navigationTitle("Inventory")
            .navigationSplitViewColumnWidth(400)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Filters", systemImage: "slider.vertical.3") {
                        if colVis == .doubleColumn {
                            colVis = .detailOnly
                        } else {
                            colVis = .doubleColumn
                        }
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
        }
        .navigationSplitViewStyle(.balanced)
        
        
    }
    
//    func getColumns(forWidth width: CGFloat) -> TableColumnContent {
//        print("Getting columns")
//    }
    
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
    
    @State var display: DisplayState = .inventoryList
    
    @ViewBuilder var menu: some View {
        VStack(spacing: 16) {
            
            Spacer()
            
            ForEach(DisplayState.allCases, id: \.self) { data in
                Button {
                    display = data
                } label: {
                    HStack(spacing: 16) {
                            Text(data.menuButtonText)
                            Spacer()
                        
                        Image(systemName: data.menuIconName)
                        RoundedCorner(radius: 8, corners: [.topLeft, .bottomLeft])
                            .fill(.white)
                            .frame(width: 6)
                            .opacity(data == display ? 1 : 0)
                            .offset(x: 3)
                    }
                    .modifier(MenuButtonMod(isSelected: data == display))
                }
                
            } //: For Each
            
            Spacer()
            
            Button {
//                showingLockScreen = true
            } label: {
                HStack(spacing: 16) {
                        Text("Lock")
                        Spacer()
                    Image(systemName: "lock")
                    RoundedCorner(radius: 8, corners: [.topLeft, .bottomLeft])
                        .fill(.white)
                        .frame(width: 6)
                        .opacity(0)
                        .offset(x: 3)
                } //: HStack
                .modifier(MenuButtonMod(isSelected: false))
            }
            
        } //: VStack
//        .frame(width: menuState.idealWidth)
        .background(.accent)
//        .fullScreenCover(isPresented: $showingLockScreen) {
//            ResponsiveView { props in
//                LockScreenView(uiProperties: props)
//            }
//        }
    }
}

#Preview {
    ResponsiveView { props in
        NavExperiment(uiProperties: props)
            .environment(\.realm, DepartmentEntity.previewRealm)
    }
}
