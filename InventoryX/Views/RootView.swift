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
    @State var selectedItem: ItemEntity?
    
    @State var showingOnboarding: Bool = false
    
    /// Conditions required for menu to display.
    var shouldShowMenu: Bool {
        let c1: Bool = uiProperties.horizontalSizeClass == .regular && cartState != .confirming
        let c2: Bool = uiProperties.width > 840 || menuState == .open
        return c1 && c2
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
                VStack {
                    HStack {
                        Text("Inventory List")
                        Spacer()
                        Button {
                            selectedItem = ItemEntity()
                        } label: {
                            Image(systemName: "plus")
                        }
                    } //: HStack
                    .padding()
                    .font(.title)
                    .fontDesign(.rounded)
                    
                    ItemTableView(department: $selectedDepartment, style: .list) { item in
                        self.selectedItem = item
                    }
                    .onAppear {
                        selectedDepartment = nil
                    }
                    .sheet(item: $selectedItem) { item in
                        AddItemView(item: item)
                    }
                } //: VStack
                
            case .departments:
                DepartmentsView()
                
            case .settings:
                SettingsView()
                
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
