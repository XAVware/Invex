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

struct RootView: View {
    let uiProperties: LayoutProperties
    @StateObject var vm = RootViewModel()
    @StateObject var posVM = PointOfSaleViewModel()
    @State var currentDisplay: DisplayState = .makeASale
    @State var menuState: MenuState = .compact
    @State var cartState: CartState = .sidebar
    
    @State var selectedDepartment: DepartmentEntity?
    
    @State var showingOnboarding: Bool = false

    var shouldShowMenu: Bool {
        return uiProperties.horizontalSizeClass == .regular && cartState != .confirming 
    }
    
    var body: some View {
        HStack(spacing: 0) {
            if shouldShowMenu {
                MenuView(display: $currentDisplay, menuState: $menuState)
                    .frame(maxWidth: menuState == .open ? uiProperties.width * 0.2 : nil)
            }
            
            switch currentDisplay {
            case .makeASale:
                PointOfSaleView(menuState: $menuState, cartState: $cartState, display: $currentDisplay)
                    .environmentObject(posVM)

            case .inventoryList:
                ItemTableView(department: $selectedDepartment, style: .list) { item in
                    // Display item in view/edit item view.
                }
                .onAppear {
                    selectedDepartment = nil
                }

            case .settings:
                SettingsView()
            }
            
        } //: HStack
        .onReceive(vm.$companyExists) { exists in
            showingOnboarding = !exists
        }
        .fullScreenCover(isPresented: $showingOnboarding) {
            OnboardingView()
                .ignoresSafeArea(.all)
        }
        
    } //: Body
    
}

#Preview {
    ResponsiveView { props in
        RootView(uiProperties: props)
            .environment(\.realm, DepartmentEntity.previewRealm) 
    }
}
