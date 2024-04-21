//
//  NavExperiment.swift
//  InventoryX
//
//  Created by Ryan Smetana on 4/18/24.
//

import SwiftUI
import RealmSwift

struct NavExperiment: View {
    // NEW
    @State var colVis: NavigationSplitViewVisibility = .doubleColumn
    @State var prefCompactCol: NavigationSplitViewColumn = .detail
    @State var contentWidth: CGFloat = 64
    
    // ROOT VIEW
    let uiProperties: LayoutProperties
    @StateObject var rootVM = RootViewModel()
    @StateObject var posVM = PointOfSaleViewModel()
    @State var currentDisplay: DisplayState = .makeASale
    @State var menuState: MenuState
    @State var cartState: CartState
    
    @State var showingOnboarding: Bool = false
    
    
    // INVENTORY LIST
    @ObservedResults(DepartmentEntity.self) var departments
//    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
//    @Environment(\.layoutDirection) private var layoutDirection
//    @StateObject var invListVM = InventoryListViewModel()
    
    @State var showDepartmentDetail: Bool = false
//    @State var showItemDetail: Bool = false
//    @State var showMoveItems: Bool = false
    
    // For when a user taps edit department.
    @State var editingDepartment: DepartmentEntity?
    
    // Department filter
    @State var selectedDepartment: DepartmentEntity?
    @State var selectedItem: ItemEntity?
    
//    @State var showRemoveItemsAlert: Bool = false
//    @State var showDeleteConfirmation: Bool = false
    
    /// Used for small screens
    @State var columnData: [ColumnHeaderModel] = [
        ColumnHeaderModel(headerText: "Item", sortDescriptor: ""),
        ColumnHeaderModel(headerText: "Stock", sortDescriptor: ""),
        ColumnHeaderModel(headerText: "Price", sortDescriptor: ""),
        ColumnHeaderModel(headerText: "Cost", sortDescriptor: "")
    ]
    
//    let uiProperties: LayoutProperties
    @State var showingLockScreen: Bool = false

    // MARK: - SETTINGS VARIABLES
//    let termsOfServiceURL: URL = URL(string: "https://xavware.com/invex/termsOfService")!
//    let privacyPolicyURL: URL = URL(string: "https://xavware.com/invex/privacyPolicy")!
//    
//    @StateObject var settingsVM: SettingsViewModel = SettingsViewModel()
//    
//    @State var showingCompanyDetail: Bool = false
//    @State var showPasscodeView: Bool = false
//    @State var showDeleteAccountConfirmation: Bool = false
    
    var body: some View {
        ZStack {
            NavigationSplitView(columnVisibility: $colVis, preferredCompactColumn: $prefCompactCol) {
                menu
            } detail: {
                NavigationSplitView(columnVisibility: .constant(.detailOnly), preferredCompactColumn: .constant(.detail)) {
                    
                } detail: {
                    HStack {
                        // MARK: - COMPACT MENU
////                        if colVis != .doubleColumn {
////                            VStack(spacing: 16) {
////                                Spacer()
////
////                                ForEach(DisplayState.allCases, id: \.self) { data in
////                                    Button {
////                                        display = data
////                                    } label: {
////                                        HStack(spacing: 16) {
////
////                                            Image(systemName: data.menuIconName)
////                                            RoundedCorner(radius: 8, corners: [.topLeft, .bottomLeft])
////                                                .fill(.white)
////                                                .frame(width: 6)
////                                                .opacity(data == display ? 1 : 0)
////                                                .offset(x: 3)
////                                        }
////                                        .modifier(MenuButtonMod(isSelected: data == display))
////                                    }
////
////                                } //: For Each
////
////                                Spacer()
////
////                                Button {
////                                    showingLockScreen = true
////                                } label: {
////                                    Image(systemName: "lock")
////
////
////                                }
////                                .modifier(MenuButtonMod(isSelected: false))
////
////                            } //: VStack
////                            .frame(width: display == .inventoryList ? .infinity : 64)
////                            .background(.accent)
////                            .fullScreenCover(isPresented: $showingLockScreen) {
////                                // TODO: This shouldnt need to be a responsive view.
////                                ResponsiveView { props in
////                                    LockScreenView(uiProperties: props)
////                                }
////                            }
//                        }
                        switch display {
                        case .makeASale:
                            PointOfSaleView(menuState: .constant(.compact), cartState: .constant(.sidebar), uiProperties: uiProperties)
                                .environmentObject(posVM)
                            
                        case .inventoryList:
                            NewInventoryListView()
                            //                .navigationSplitViewStyle(.balanced)
                        case .settings:
                            EmptyView()
                        }
                    } //: Group - Detail
                }
                .navigationSplitViewStyle(.balanced)
                
                
            }
            .tint(colVis == .detailOnly ? .accent : Color("Purple050"))
            .navigationSplitViewStyle(.balanced)
            .onChange(of: display, { oldValue, newValue in
                print("Changing content width from \(oldValue.contentStackWidth) to \(newValue.contentStackWidth)")
                contentWidth = newValue.contentStackWidth
            })
            .onChange(of: colVis) { oldValue, newValue in
                print("Column Visibility: \(newValue)")
            }
            .toolbar {
                if display == .inventoryList {
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
        }
            
//            NavigationSplitView(columnVisibility: $colVis, preferredCompactColumn: $prefCompactCol) {
////                menu
//                //                .navigationSplitViewColumnWidth(280)
//            } content: {
//                menu
////                Group {
////                    HStack {
////                        // MARK: - COMPACT MENU
////                        if colVis != .all {
////                            VStack(spacing: 16) {
////                                Spacer()
////                                
////                                ForEach(DisplayState.allCases, id: \.self) { data in
////                                    Button {
////                                        display = data
////                                    } label: {
////                                        HStack(spacing: 16) {
////                                            
////                                            Image(systemName: data.menuIconName)
////                                            RoundedCorner(radius: 8, corners: [.topLeft, .bottomLeft])
////                                                .fill(.white)
////                                                .frame(width: 6)
////                                                .opacity(data == display ? 1 : 0)
////                                                .offset(x: 3)
////                                        }
////                                        .modifier(MenuButtonMod(isSelected: data == display))
////                                    }
////                                    
////                                } //: For Each
////                                
////                                Spacer()
////                                
////                                Button {
////                                    showingLockScreen = true
////                                } label: {
////                                    Image(systemName: "lock")
////                                    
////                                    
////                                }
////                                .modifier(MenuButtonMod(isSelected: false))
////                                
////                            } //: VStack
////                            .frame(width: display == .inventoryList ? .infinity : 64)
////                            .background(.accent)
////                            .fullScreenCover(isPresented: $showingLockScreen) {
////                                // TODO: This shouldnt need to be a responsive view.
////                                ResponsiveView { props in
////                                    LockScreenView(uiProperties: props)
////                                }
////                            }
////                        }
////                        
////                        
////                        // MARK: - ADDITIONAL CONTENT VIEWS
////                        switch display {
////                        case .makeASale:
////                            EmptyView()
////                            
////                        case .inventoryList:
////                            // MARK: - INVENTORY LIST FILTERS VIEW
////                            VStack {
////                                Menu {
////                                    ForEach(departments) { dept in
////                                        Button {
////                                            selectedDepartment = dept
////                                        } label: {
////                                            Text(dept.name)
////                                        }
////                                    }
////                                } label: {
////                                    Text("Department:")
////                                        .font(.caption)
////                                    
////                                    Spacer()
////                                    
////                                    Text("Select")
////                                        .font(.caption2)
////                                }
////                                .padding(.horizontal)
////                                .frame(minHeight: 32, idealHeight: 36, maxHeight: 40)
////                                .background(.ultraThinMaterial)
////                                .clipShape(Capsule())
////                                .shadow(radius: 1)
////                                
////                                
////                                Spacer()
////                            } //: VStack
////                            .padding([.vertical, .leading])
////                            .padding(.trailing, 2)
////                            .background(Color("Purple050").opacity(0.2))
////                            //            .navigationTitle("Filters")
////                            .navigationSplitViewColumnWidth(min: 180, ideal: 240, max: 280)
////                            .onAppear {
////                                //                            guard let dept = departments.first, !isCompact else { return }
////                                selectedDepartment = departments.first
////                            }
////                            
////                        case .settings:
////                            NewSettingsView()
////                        }
////                    }
////                    
////                    
////                    
////                    
////                } //: Group - Content
////                .navigationSplitViewColumnWidth(contentWidth)
////                .navigationSplitViewStyle(.balanced)
//                // MARK: - DETAIL VIEW
//            } detail: {
//                Group {
//                    switch display {
//                    case .makeASale:
//                        PointOfSaleView(menuState: .constant(.compact), cartState: .constant(.sidebar), uiProperties: uiProperties)
//                            .environmentObject(posVM)
//                        
//                    case .inventoryList:
//                        NewInventoryListView()
//                        //                .navigationSplitViewStyle(.balanced)
//                    case .settings:
//                        EmptyView()
//                    }
//                } //: Group - Detail
//            }
//            .navigationSplitViewStyle(.balanced)
//                
//            
//            
//        } //: ZStack
//        .onChange(of: display, { oldValue, newValue in
//            print("Changing content width from \(oldValue.contentStackWidth) to \(newValue.contentStackWidth)")
//            contentWidth = newValue.contentStackWidth
//        })
//        .onChange(of: colVis) { oldValue, newValue in
//            print("Column Visibility: \(newValue)")
//        }
//        .toolbar {
//            if display == .inventoryList {
//                ToolbarItem(placement: .topBarLeading) {
//                    Button("Filters", systemImage: "slider.vertical.3") {
//                        if colVis == .doubleColumn {
//                            colVis = .detailOnly
//                        } else {
//                            colVis = .doubleColumn
//                        }
//                    }
//                } //: Toolbar Item - Filters Button
//                
//                ToolbarItemGroup(placement: .topBarTrailing) {
//                    Button("Department", systemImage: "plus") {
//                        editingDepartment = DepartmentEntity()
//                    }
//                    .buttonStyle(BorderedButtonStyle())
//                    
//                    Button("Item", systemImage: "plus") {
//                        selectedItem = ItemEntity()
//                    }
//                    .buttonStyle(BorderedButtonStyle())
//                }
//            }
//        }
        
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
                        
//                        departmentMenu
//                            .font(.title2)
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
        NavExperiment(uiProperties: props, menuState: MenuState.compact, cartState: CartState.sidebar)
            .environment(\.realm, DepartmentEntity.previewRealm)
    }
}
