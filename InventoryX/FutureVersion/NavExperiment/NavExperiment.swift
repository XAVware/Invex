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
    @State var colVis: NavigationSplitViewVisibility = .detailOnly
    @State var prefCompactCol: NavigationSplitViewColumn = .detail
//    @State var contentWidth: CGFloat = 64
    
    // ROOT VIEW
    let uiProperties: LayoutProperties
    @StateObject var rootVM = RootViewModel()
    @StateObject var posVM = PointOfSaleViewModel()
    @State var currentDisplay: DisplayState = .settings
//    @State var menuState: MenuState
    @State var cartState: CartState
    
    @State var showingOnboarding: Bool = false
    
    
    // INVENTORY LIST
//    @ObservedResults(DepartmentEntity.self) var departments
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
    
    @State var showingLockScreen: Bool = false

    @State var childColVis: NavigationSplitViewVisibility = .detailOnly
    
    var body: some View {
        ZStack {
            switch currentDisplay {
            case .makeASale:
                NewPointOfSaleView(cartState: .constant(.sidebar), uiProperties: uiProperties, currentDisplay: $currentDisplay)
                    .environmentObject(posVM)

            case .inventoryList:
                NewInventoryListView(currentDisplay: $currentDisplay)
//                            .toolbar(.hidden, for: .navigationBar)
                    
            case .settings:
                NewSettingsView(currentDisplay: $currentDisplay)
                
                
            }
        } //: Group - Detail
        
//            NavigationSplitView(columnVisibility: $colVis, preferredCompactColumn: $prefCompactCol) {
//                menu
//            } detail: {
//                
//                Group {
//                    
//                .navigationSplitViewStyle(.balanced)
//                .toolbar(.hidden, for: .navigationBar)
//                .toolbar {
//                    ToolbarItem(placement: .topBarLeading) {
//                        Button("Filters", systemImage: "slider.vertical.3") {
//                            if childColVis == .doubleColumn {
//                                childColVis = .detailOnly
//                            } else {
//                                childColVis = .doubleColumn
//                            }
//                        }
//                    } //: Toolbar Item - Filters Button
//                    
//                    ToolbarItemGroup(placement: .topBarTrailing) {
//                        Button("Department", systemImage: "plus") {
//                            editingDepartment = DepartmentEntity()
//                        }
//                        .buttonStyle(BorderedButtonStyle())
//                        
//                        Button("Item", systemImage: "plus") {
//                            selectedItem = ItemEntity()
//                        }
//                        .buttonStyle(BorderedButtonStyle())
//                    }
//
//                    ToolbarItem(placement: .topBarTrailing) {
//                        Button {
//                        } label: {
//                            Image(systemName: "cart")
//                        }
//                    }
//                }
//            }
//            
//        }
//        .tint(colVis == .detailOnly ? .accent : Color("Purple050"))
        
    }
    
    private var compactMenu: some View {
//        if colVis != .doubleColumn {
            VStack(spacing: 16) {
                Spacer()

                ForEach(DisplayState.allCases, id: \.self) { data in
                    Button {
                        currentDisplay = data
                    } label: {
                        HStack(spacing: 16) {

                            Image(systemName: data.menuIconName)
                            RoundedCorner(radius: 8, corners: [.topLeft, .bottomLeft])
                                .fill(.white)
                                .frame(width: 6)
                                .opacity(data == currentDisplay ? 1 : 0)
                                .offset(x: 3)
                        }
                        .modifier(MenuButtonMod(isSelected: data == currentDisplay))
                    }

                } //: For Each

                Spacer()

                Button {
                    showingLockScreen = true
                } label: {
                    Image(systemName: "lock")


                }
                .modifier(MenuButtonMod(isSelected: false))

            } //: VStack
            .frame(width: currentDisplay == .inventoryList ? .infinity : 64)
            .background(.accent)
            .fullScreenCover(isPresented: $showingLockScreen) {
                // TODO: This shouldnt need to be a responsive view.
                ResponsiveView { props in
                    LockScreenView(uiProperties: props)
                }
            }
//        }
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
        
    @ViewBuilder var menu: some View {
        VStack(spacing: 16) {
            
            Spacer()
            
            ForEach(DisplayState.allCases, id: \.self) { data in
                Button {
                    currentDisplay = data
                } label: {
                    HStack(spacing: 16) {
                        Text(data.menuButtonText)
                        Spacer()
                        
                        Image(systemName: data.menuIconName)
                        RoundedCorner(radius: 8, corners: [.topLeft, .bottomLeft])
                            .fill(.white)
                            .frame(width: 6)
                            .opacity(data == currentDisplay ? 1 : 0)
                            .offset(x: 3)
                    }
                    .modifier(MenuButtonMod(isSelected: data == currentDisplay))
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
        NavExperiment(uiProperties: props, cartState: CartState.sidebar)
            .environment(\.realm, DepartmentEntity.previewRealm)
    }
}
