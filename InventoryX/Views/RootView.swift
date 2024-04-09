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
    @State var menuState: MenuState = .compact
    @State var cartState: CartState = .sidebar
    
    
    @State var showingOnboarding: Bool = false
    
    /// Conditions required for menu to display.
    var shouldShowMenu: Bool {
        let condition1: Bool = uiProperties.horizontalSizeClass == .regular && cartState != .confirming
        let condition2: Bool = uiProperties.width > 840 || menuState == .open
        return condition1 && condition2
    }
    
    var body: some View {
        HStack(spacing: 0) {
            if shouldShowMenu {
                MenuView(display: $currentDisplay, menuState: $menuState)
            }
            
            switch currentDisplay {
            case .makeASale:
                PointOfSaleView(menuState: $menuState, cartState: $cartState)
                    .environmentObject(posVM)
                
            case .inventoryList:    InventoryListView()
            case .departments:      DepartmentsView()
            case .settings:         SettingsView()
            }
        } //: HStack
        .onReceive(vm.$companyExists) { exists in
            showingOnboarding = !exists
        }
        .fullScreenCover(isPresented: $showingOnboarding) {
            OnboardingView()
        }
        
    } //: Body
    
}

#Preview {
    ResponsiveView { props in
        RootView(uiProperties: props)
            .environment(\.realm, DepartmentEntity.previewRealm) 
    }
}
