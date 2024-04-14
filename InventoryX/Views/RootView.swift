//
//  RootView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/19/24.
//

import SwiftUI
import RealmSwift
import Combine

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

// Use cmd + M for long initializer formatting

/// PointOfSaleViewModel is initialized in the root so a user's cart is not lost when 
/// they switch screens.
///
/// Menu shouldn't be open while cart is a sidebar and vice versa.
///
/// Future features:
///     - Try to find pattern in pricing/percentage data added by user and change 
///     pickers/sliders to behave accordingly
///         -> i.e. if all prices end in 0, price pickers should not default to increments
///         less than 0.1

struct RootView: View {
    let uiProperties: LayoutProperties
    @StateObject var vm = RootViewModel()
    @StateObject var posVM = PointOfSaleViewModel()
    @State var currentDisplay: DisplayState = .makeASale
    @State var menuState: MenuState
    @State var cartState: CartState
    
    @State var showingOnboarding: Bool = false
    
    init(uiProperties: LayoutProperties) {
        self.uiProperties = uiProperties
        
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
        
        print("Main width: \(uiProperties.width)")
        print("Menu state initialized to: \(menuState)")
        print("Cart state initialized to: \(cartState)")
    }
    
    /// Conditions required for menu to display.
    var shouldShowMenu: Bool {
        let c1: Bool = cartState != .confirming
        let c2: Bool = uiProperties.width > 840
        let c3: Bool = menuState == .open
        let shouldShow = (c1 && c2) || c3
        print("Should show menu: \(shouldShow)")
        print("Should show overlay button: \(!shouldShow)")
        return shouldShow
    }

    
    /// Open or close the menu depending on the current MenuState. On large 
    /// screens the menu never closes fully, so .compact is considered .closed
    /// for larger screens. Then, if the view is large enough, always show a
    /// compact menu instead of hiding it.
    func toggleMenu() {
        var newMenuState: MenuState = (menuState == .closed || menuState == .compact) ? .open : .closed
        
        if newMenuState == .closed && uiProperties.width > 840 {
            newMenuState = .compact
        }
        
        withAnimation(.interpolatingSpring) {
            menuState = newMenuState
            if menuState == .open {
                cartState = .closed
            }
        }
    }
    
    var body: some View {
        /// Don't show the menu when `cartState == .confirming`. The menu can be compact when the width is over 840
        HStack(spacing: 0) {
            if cartState != .confirming {
                if shouldShowMenu || uiProperties.width > 840 {
                    MenuView(display: $currentDisplay, menuState: $menuState) {
                        toggleMenu()
                    }
                }
            }
            
            /// Group views so TapGesture can be recognized when screen is tapped
            /// outside of menu bounds.
            Group {
                switch currentDisplay {
                case .makeASale:
                    PointOfSaleView(menuState: $menuState, cartState: $cartState, uiProperties: uiProperties)
                        .environmentObject(posVM)
                    
                case .inventoryList:
                    ResponsiveView { props in
                        InventoryListView(uiProperties: props)
                    }
                    .padding(.top)
                    
                case .departments:      
                    DepartmentsView()
                        .padding(.top)
                    
                case .settings:         
                    SettingsView()
                        .padding(.top)
                }
            }
            
            .background(.accent.opacity(0.0001))
            .onTapGesture(coordinateSpace: .global) { location in
                if menuState == .open {
                    withAnimation(.interpolatingSpring) {
                        menuState = .closed
                    }
                }
            }
        } //: HStack
        .overlay(smallViewMenuBtn, alignment: .topLeading)
        .onChange(of: menuState) { newValue in
            if newValue == .closed {
                /// Try to show a compact menu when the menu state is closed. The 
                /// compact menu should only be displayed when the view is greater than 840
                if uiProperties.width > 840 {
                    menuState = .compact
                }
            }
        }
        .onChange(of: currentDisplay) { _ in
            guard menuState == .open else { return }
            withAnimation(.interpolatingSpring) {
                menuState = .closed
            }
        }
        .onReceive(vm.$companyExists) { exists in
            showingOnboarding = !exists
        }
//        .fullScreenCover(isPresented: $showingOnboarding) {
//            OnboardingView()
//        }
        
    } //: Body
    
    /// Menu button is presented as an overlay in the top left corner when the menuState 
    /// is closed and the screen is not wide enough to display a compact menu. Make sure
    /// the button is not being displayed when cartState is confirming.
    @ViewBuilder private var smallViewMenuBtn: some View {
        if (menuState == .closed || uiProperties.width < 840) && cartState != .confirming {
            Button {
                toggleMenu()
            } label: {
                Image(systemName: "line.3.horizontal")
            }
            .font(.title)
            .padding()
            .fontDesign(.rounded)
            
        }
    }
    
}

#Preview {
    ResponsiveView { props in
        RootView(uiProperties: props)
            .environment(\.realm, DepartmentEntity.previewRealm)
    }
}
