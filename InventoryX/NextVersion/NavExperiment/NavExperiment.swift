//
//  NavExperiment.swift
//  InventoryX
//
//  Created by Ryan Smetana on 4/18/24.
//

/// Navigation Architecture
///
/// Problem: The overall flow of the app is similar to the built in flow of a NavigationSplitView. The menu could be a sidebar but that would require that views like Settings to have a Content view while other screens like PointOfSaleView to have empty Content in the split view. NavigationSplitView doesn't act correct if you attempt to use empty views or dynamically move views from sidebar-content-detail depending on the screen.
///
/// Solution: Use a ZStack to show and hide the menu and a NavigationSplit view that only has a sidebar and detail for the main content of the app.
/// Hide the default sidebar button so I can create a replica and add additional logic. The button needs to check what view is open and either show the menu or show the sidebar depending on what is required.
/// Majority of views will have a column visibility state of detailOnly, while views like settings will use .doubleColumn. In iOS 17 you can use PreferredCompactColumn to default to .detailView for PointOfSaleView, InventoryListView, etc. while using .sidebar for SettingsView.

import SwiftUI
import RealmSwift

enum NewMenuState: Equatable {
    case open
    case closed
    
    var width: CGFloat { 320 }
    
    var xOffset: CGFloat {
        return switch self {
        case .open: 0
        case .closed: -width
        }
    }
    
    
}



enum NewDisplayState: CaseIterable {
    case pointOfSale
    case inventoryList
//    case salesHistory
    case settings
    
    var menuButtonText: String {
        return switch self {
        case .pointOfSale:        "Sale"
        case .inventoryList:    "Inventory"
//        case .salesHistory:     "Sales"
        case .settings:         "Settings"
        }
    }
    
    var menuIconName: String {
        return switch self {
        case .pointOfSale:        "cart.fill"
        case .inventoryList:    "tray.full.fill"
//        case .salesHistory:     "chart.xyaxis.line"
        case .settings:         "gearshape"
        }
    }
    
    var primaryView: NavigationSplitViewVisibility {
            return switch self {
            case .pointOfSale: .detailOnly
            case .inventoryList: .detailOnly
            case .settings: .doubleColumn
            }
        
    }
    
    /// A display state requires a custom menu if the layout has a view it wants to display in the `sidebar` section of the split view. If there is something in the sidebar section, the sidebar can't be used for the menu so a custom menu is required.
    var requiresCustomMenu: Bool {
        return switch self {
        case .pointOfSale:      false
        case .inventoryList:    false
        case .settings:         true
        }
    }
    
    var isDetailProminent: Bool {
        return switch self {
        case .pointOfSale:      true
        case .inventoryList:    true
        case .settings:         false
        }
    }

}


enum NewCartState {
    case closed
    case sidebar
    case confirming
    
    var width: CGFloat {
        return switch self {
        case .closed:       0
        case .sidebar:      240
        case .confirming:   .infinity
        }
    }
}

class NavExperimentViewModel: ObservableObject {
    @Published var colVis: NavigationSplitViewVisibility = .detailOnly
}


struct NavView<Content: View, Detail: View>: View {
    
    @Binding var currentDisplay: NewDisplayState
    let content: Content?
    let detail: Detail
    
    @State var colVis: NavigationSplitViewVisibility = .doubleColumn
    @State var showingLockScreen: Bool = false
    
    
    init(display: Binding<NewDisplayState>, content: (() -> Content)? = nil, @ViewBuilder detail: () -> Detail) {
        self._currentDisplay = display
        self.content = content?()
        self.detail = detail()
        
        if content == nil {
            print("Content is nil")
        } else {
            print("Content is not nil")
        }
    }
    
    func changeDisplay(to newDisplay: NewDisplayState) {
        if newDisplay == .settings {
            currentDisplay = newDisplay
            
            withAnimation {
                colVis = .all
                colVis = .doubleColumn
            }
        } else {
            currentDisplay = newDisplay
            withAnimation {
                colVis = currentDisplay.primaryView
            }
        }
    }
    
    @State var xOffset: CGFloat = 0
    
    var body: some View {
        if currentDisplay.primaryView == .detailOnly {
            NavigationSplitView(columnVisibility: $colVis) {
                menu
            } detail: {
                detail
            }

        } else {
            NavigationSplitView(columnVisibility: $colVis) {
                menu
            } content: {
                content
            } detail: {
                detail
                
            }
            
//            .offset(x: xOffset)
        }
    }
    
    @ViewBuilder var menu: some View {
        VStack(spacing: 16) {
            Spacer()
            
            ForEach(NewDisplayState.allCases, id: \.self) { data in
                Button {
                    changeDisplay(to: data)
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
                showingLockScreen = true
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
        .background(.accent)
        .fullScreenCover(isPresented: $showingLockScreen) {
            LockScreenView()
        }
    }
}

// Support optional footer
extension NavView where Content == EmptyView {
    init(display: Binding<NewDisplayState>, @ViewBuilder detail: () -> Detail) {
        self._currentDisplay = display
        self.content = nil
        self.detail = detail()
    }
}








struct NavExperiment: View {
    // NEW
    @StateObject var vm = NavExperimentViewModel()
//    @State var colVis: NavigationSplitViewVisibility = .all
    @State var prefCompactCol: NavigationSplitViewColumn = .detail
    
    
    // ROOT VIEW
    let uiProperties: LayoutProperties
    @StateObject var rootVM = RootViewModel()
    @StateObject var posVM = PointOfSaleViewModel()
    @State var currentDisplay: NewDisplayState = .pointOfSale
    @State var menuState: NewMenuState = .closed
    @State var cartState: NewCartState = .closed
    
    @State var showingOnboarding: Bool = false
    
    @State var showingLockScreen: Bool = false

    @State var sidebarButtonBackground: Color = .accent
    
    func toggleCustomMenu() {
        print("Custom menu button tapped")
        if menuState == .open {
            hideCustomMenu()
        } else {
            showCustomMenu()
        }

    }
    
    func showCustomMenu() {
        guard menuState != .open else { return }
        withAnimation {
            menuState = .open
        }
    }
    
    func hideCustomMenu() {
        guard menuState != .closed else { return }
        withAnimation {
            menuState = .closed
        }
    }

    // nav offset should always be menu's starting point + menu width + current point
    var navOffset: CGFloat {
        if currentDisplay.primaryView == .detailOnly || menuState == .closed { return 0 }
        let startPosX = -menuState.width
        let currentPosX = menuState.width
        let offset = startPosX + currentPosX + menuState.width
        return offset
    }
    
    func changeDisplay(to newDisplay: NewDisplayState) {
        let prevDisplay = currentDisplay
        if prevDisplay.requiresCustomMenu && !newDisplay.requiresCustomMenu {
            menuState = .closed
        }
        
        if newDisplay == .settings {
            // It takes some time for the navigation split view to render with the sidebar section open. Display menu animation above the rendering delay
            currentDisplay = newDisplay
            toggleCustomMenu()
        } else {
            // If the destination doesn't require a custom menu, the menu is in the sidebar of the split view.
            hideCustomMenu()
            currentDisplay = newDisplay
        }
        
    }

    var body: some View {
        ZStack {
            NavView(display: $currentDisplay) {
                sidebarView
            } detail: {
                NavigationStack {
                    detailView
                }
            }
            

//            NavigationSplitView(columnVisibility: $vm.colVis, preferredCompactColumn: $prefCompactCol) {
//                sidebarView
//                    .navigationBarBackButtonHidden(true)
//                    .toolbar(removing: currentDisplay.requiresCustomMenu ? .sidebarToggle : nil) // Remove default if custom is required
//                    .toolbar {
//                        if currentDisplay.requiresCustomMenu {
//                            ToolbarItem(placement: .topBarLeading) {
//                                Button("Sidebar", systemImage: "sidebar.left") {
//                                    toggleCustomMenu()
//                                }
//                                .foregroundStyle(menuState == .open ? Color("lightAccent") : Color("bgColor"))
//                            }
//                        }
//                    }
//            } detail: {
//                NavigationStack {
//                    detailView
//                }
//            }
//            .offset(x: navOffset)
            
//            cartLayer
//            customMenuLayer
            
        } //: ZStack
        .onReceive(vm.$colVis, perform: { newVis in
            /// The user tapped the menu button which changed the NavigationSplitViewColumnVisibility. The state of the `customMenu` needs to be synced up. If the previous state was detail only and the new state is doubleColumn or all, the user opened the menu
            print("Col vis changed to: \(newVis)")
            if newVis != .detailOnly && !currentDisplay.requiresCustomMenu {
                print("TRig")
                showCustomMenu()
            }
        })
        .onChange(of: menuState) { oldValue, newValue in
            print("Menu state is: \(newValue)")
            if newValue == .closed {
                vm.colVis = currentDisplay.primaryView
            }
        }
        
    } //: Body
    
    @ViewBuilder var sidebarView: some View {
        if currentDisplay == .settings {
            NewSettingsView()
                
        } else {
            menu
                .overlay(Color.green.frame(width: 48, height: 48), alignment: .topTrailing)
            
        }
    }
    
    
    @ViewBuilder var detailView: some View { 
        switch currentDisplay {
        case .pointOfSale:
            NewPointOfSaleView(cartState: .constant(.sidebar), uiProperties: uiProperties)
                .environmentObject(posVM)

            
        case .inventoryList:
            NewInventoryListView()

            
        default: Color.clear
            
        }
    }
    
    @ViewBuilder var cartLayer: some View {
        HStack {
            Spacer()
            NewCartView(cartState: $cartState, uiProperties: uiProperties)
                .frame(maxWidth: cartState.width)
//                    .offset(x: menuState.xOffset)
        }
    }
    
    @ViewBuilder var customMenuLayer: some View {
        if currentDisplay.requiresCustomMenu {
            HStack {
                menu
                    .frame(maxWidth: menuState.width)
                    .overlay(Color.red.frame(width: 48, height: 48), alignment: .topTrailing)
                    .offset(x: menuState.xOffset)
                    .transition(.move(edge: .leading))
                
                Color.white.opacity(0.00001)
            } //: HStack
            .onTapGesture(coordinateSpace: .global) { location in
                if menuState == .open && location.x > menuState.width {
                    hideCustomMenu()
                }
            }
        }
    }
    
    @ViewBuilder var menu: some View {
        VStack(spacing: 16) {
            Spacer()
            
            ForEach(NewDisplayState.allCases, id: \.self) { data in
                Button {
                    changeDisplay(to: data)
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
                showingLockScreen = true
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
        .background(.accent)
        .fullScreenCover(isPresented: $showingLockScreen) {
            LockScreenView()
        }
    }
}

#Preview {
    ResponsiveView { props in
        NavExperiment(uiProperties: props, cartState: NewCartState.sidebar)
            .environment(\.realm, DepartmentEntity.previewRealm)
            .environmentObject(PointOfSaleViewModel())
    }
}
