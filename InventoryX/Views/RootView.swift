//
//  RootView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/19/24.
//

import SwiftUI
import RealmSwift
import Combine

class RootViewModel: ObservableObject {
    
    private let service = AuthService.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var companyExists: Bool = false    
    
    init() {
        configureSubscribers()
    }
    
    func configureSubscribers() {
        service.$exists
            .sink { [weak self] exists in
                self?.companyExists = exists
            }
            .store(in: &cancellables)
    }
}

/// PointOfSaleViewModel is initialized in the root so a user's cart is not lost when they switch screens.
struct RootView: View {
    let uiProperties: LayoutProperties
    @StateObject var vm = RootViewModel()
    @StateObject var posVM = PointOfSaleViewModel()
    @State var currentDisplay: DisplayState = .makeASale
    @State var menuState: MenuState
    @State var cartState: CartState
    
    
    @State var showingOnboarding: Bool = false
    
    
    init(uiProperties: LayoutProperties) {
        print("-- Root Initializing --")
        self.uiProperties = uiProperties
        
//        if menuState == .open {
            if uiProperties.width < 680 {
                // Both menu and cart should default to closed
                menuState = .closed
                cartState = .closed
            } else if uiProperties.width < 840 {
                // Menu should default to closed. Cart should default to sidebar
                menuState = .closed
                cartState = .sidebar
            } else {
                // Screen is wider than 840
                // Menu should default to compact. Cart should default to sidebar
                menuState = .compact
                cartState = .sidebar
            }
//        }
        
        print("Main width: \(uiProperties.width)")
        print("Menu state initialized to: \(menuState)")
        print("Cart state initialized to: \(cartState)")
    }
    
    /// Conditions required for menu to display.
    var shouldShowMenu: Bool {
//        guard menuState != .open else { return true }
//        let c1: Bool = uiProperties.horizontalSizeClass == .regular && cartState != .confirming
        let c1: Bool = cartState != .confirming
        let c2: Bool = uiProperties.width > 840
        let c3: Bool = menuState == .open
        
        let shouldShow = (c1 && c2) || c3
        print("Should show menu: \(shouldShow)")
        
        print("Should show overlay button: \(!shouldShow)")
        return shouldShow
    }
    
    /// Checks the conditions required to show the menu button as an overlay
//    var shouldOverlayMenuButton: Bool {
//        // Don't show button when menu is open
//        let c1: Bool = menuState != .open
//        // Always show button when device is in landscape
//        let c2: Bool = uiProperties.width < 840
//        return c1 && c2
//    }
    
//    private func setupStates() {
        /// Screen widths:
        /// - iPads (non-mini)
        ///     - Portrait: 768 - 1024
        ///     - Landscape: 1024 - 1366
        ///
        /// - iPads (mini)
        ///     - Portrait: 744 - 768
        ///     - Landscape: 1024
        ///
        /// - iPhones
        ///     - Portrait: 320 - 430
        ///     - Landscape: 480 - 932
//    }
    
    
    func toggleMenu() {
        /// Open or close the menu depending on the current MenuState. On large screens the menu never closes fully, so .compact is considered .closed for larger screens.
        var newMenuState: MenuState = (menuState == .closed || menuState == .compact) ? .open : .closed
        
        /// If the view is large enough, always show a compact menu instead of hiding it.
        if newMenuState == .closed && uiProperties.width > 840 {
            newMenuState = .compact
        }
        
        if cartState == .sidebar && newMenuState == .open {
            withAnimation(.interpolatingSpring) {
                cartState = .closed
            }
        }
        
        withAnimation(.smooth) {
//            menuState = switch menuState {
//            case .open: MenuState.compact
//            case .compact: MenuState.open
//            case .closed: MenuState.open
//            }
            
            menuState = newMenuState
        }
            print("New menu state: \(newMenuState)")
    }
    
    var body: some View {
        HStack(spacing: 0) {
            if cartState != .confirming {
                if shouldShowMenu || uiProperties.width > 840 {
                    MenuView(display: $currentDisplay, menuState: $menuState) {
                        toggleMenu()
                    }
                    .onAppear {
                        print("Menu appeared with state: \(menuState)")
                    }
                    
                }
            }
//            ZStack(alignment: .leading) {
                switch currentDisplay {
                case .makeASale:
                    PointOfSaleView(menuState: $menuState, cartState: $cartState, uiProperties: uiProperties)
                        .environmentObject(posVM)
                    
                case .inventoryList:    InventoryListView()
                case .departments:      DepartmentsView()
                case .settings:         SettingsView()
                }
//                
//                Color.black
//                    .opacity(menuState == .open ? 0.4 : 0)
////                    .frame(maxWidth: menuState == .open ? .infinity : 1)
//                    .animation(nil, value: menuState == .open)
//                    .onTapGesture {
//                        menuState = .closed
//                    }
//            }
            
        } //: HStack
//        .background(.accent.opacity(0.0001))
//        .onTapGesture {
//            print("UIProperty width is: \(uiProperties.width)")
//        }
        .onChange(of: menuState) { newMenuState in
            print("Menu state changed to: \(newMenuState)")
            if newMenuState == .closed && uiProperties.width > 840 {
                print("Overriding closed menu due to large screen. Setting to compact.")
                menuState = .compact
            } else if newMenuState == .compact && uiProperties.width < 840 {
                print("Overriding compact menu due to small screen. Setting to closed.")
                menuState = .closed
            }
        }
//        .onAppear {
//            print("Main width: \(uiProperties.width)")
//            
////            if shouldOverlayMenuButton {
//            if !shouldShowMenu {
//                menuState = .closed
//            } else {
//                menuState = .compact
//            }
//            
//            if uiProperties.width < 680 {
//                menuState = .closed
//                cartState = .closed
//            } else {
//                menuState = .compact
//                cartState = .sidebar
//            }
//            print("Main width: \(uiProperties.width)")
//            print("Menu state initialized to: \(menuState)")
//            print("Cart state initialized to: \(cartState)")
//        }
        .onChange(of: menuState) { newValue in
            if newValue == .closed {
                if uiProperties.width > 840 {
                    menuState = .compact
                }
            }
        }
        .onReceive(vm.$companyExists) { exists in
            showingOnboarding = !exists
        }
        .fullScreenCover(isPresented: $showingOnboarding) {
            OnboardingView()
        }
//        .overlay(shouldOverlayMenuButton ? smallViewMenuBtn : nil, alignment: .topLeading)
//        .overlay(!shouldShowMenu ? smallViewMenuBtn : nil, alignment: .topLeading)
        .overlay(smallViewMenuBtn, alignment: .topLeading)
        
    } //: Body
    
    /// Only visible when screen width is less than 680
    @ViewBuilder private var smallViewMenuBtn: some View {
        if menuState == .closed || uiProperties.width < 840 {
//        if uiProperties.width < 840 || uiProperties.landscape == false {
            Button {
                //            var newState: MenuState = .compact
                //
                //            if uiProperties.width < 680 {
                //                newState = .closed
                //            }
                
                //            let closedState: MenuState = uiProperties.landscape == true ? .compact : .closed
                
                withAnimation(.smooth) {
                    //                menuState = menuState == .closed ? .open : .compact
                    menuState = menuState == .closed ? .open : .closed
                }
                print("Menu State changed to : \(menuState)")
            } label: {
                Image(systemName: "line.3.horizontal")
            }
            .font(.title)
            .fontDesign(.rounded)
            .foregroundStyle(.accent)
            .padding()
        }
    }
    
}

#Preview {
    ResponsiveView { props in
        RootView(uiProperties: props)
            .environment(\.realm, DepartmentEntity.previewRealm) 
    }
}
