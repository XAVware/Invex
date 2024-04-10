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
        guard menuState != .open else { return true }
        let condition1: Bool = uiProperties.horizontalSizeClass == .regular && cartState != .confirming
        let condition2: Bool = uiProperties.width > 840 || menuState == .open
        return condition1 && condition2
    }
    
    var body: some View {
        HStack(spacing: 0) {
            
            if shouldShowMenu {
                MenuView(display: $currentDisplay, menuState: $menuState)
                    .onAppear {
                        if uiProperties.width < 680 {
                            print("Main width: \(uiProperties.width)")
                            menuState = .closed
                            cartState = .hidden
                        } else {
                            menuState = .compact
                            cartState = .sidebar
                        }
                    }
            }
            
            switch currentDisplay {
            case .makeASale: 
                PointOfSaleView(menuState: $menuState, cartState: $cartState, uiProperties: uiProperties)
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
        .overlay(uiProperties.width < 680 ? smallViewMenuBtn : nil, alignment: .topLeading)
        
    } //: Body
    
    /// Only visible when screen width is less than 680
    private var smallViewMenuBtn: some View {
        Button {
            withAnimation(.smooth) {
                menuState = menuState == .closed ? .open : .closed
            }
        } label: {
            Image(systemName: "line.3.horizontal")
        }
        .font(.title)
        .fontDesign(.rounded)
        .foregroundStyle(.accent)
        .padding()
    }
    
}

#Preview {
    ResponsiveView { props in
        RootView(uiProperties: props)
            .environment(\.realm, DepartmentEntity.previewRealm) 
    }
}
