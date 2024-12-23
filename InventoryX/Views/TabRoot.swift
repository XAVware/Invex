//
//  TabRoot.swift
//  InventoryX
//
//  Created by Ryan Smetana on 9/7/24.
//

import SwiftUI
import RealmSwift
import Combine


/// PointOfSaleViewModel is initialized in the root so a user's cart is not lost when
/// they switch screens. If it were initialized in PointOfSaleView, it will re-initialize
/// every time the user goes to the point of sale view, resetting the cart.
///
/// Menu shouldn't be open while cart is a sidebar and vice versa.
///
/// Future features:
///     - Try to find pattern in pricing/percentage data added by user and change
///     pickers/sliders to behave accordingly
///         -> i.e. if all prices end in 0, price pickers should not default to increments
///         less than 0.1

// TODO: On vertical iPhone, LSXView is throwing a red warning. I think it's causing slow startup time also: "Update preferredCompactColumn binding tried to update multiple times per frame."

/*
 8.29.24 - A warning is being thrown for breaking constraints on startup on regular width devices. I thought it was related to POSView but it only happens when OnboardingView is being displayed as a full screen cover. Going to toggle onboarding with an optional isOnboarding variable in the root.
 
 9.24.24 - For the tab items, each individual tab item is wrapped in a NavigationStack as opposed to the entire TabView. Wrapping the entire TabView in a NavigationStack causes SettingsView not to work correctly on compact width devices because it is a NavigationSplitView.
 
 */

@Observable
class NavigationService {
    var path: NavigationPath = .init()
    var sidebarVisibility: SidebarState?
    var sidebarWidth: CGFloat?
    /// Toggle between hidden and sidebar cart state. Only called from regular horizontal size class devices.
    func toggleSidebar() {
        withAnimation {
            if sidebarVisibility == .hidden {
                sidebarVisibility = .showing
            } else {
                sidebarVisibility = .hidden
            }
        }
    }
}

struct TabRoot: View {
    @State private var navService: NavigationService = .init()
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var hSize
    @Environment(\.verticalSizeClass) var vSize
    
    @ObservedResults(DepartmentEntity.self) var departments
    @ObservedResults(CompanyEntity.self) var companies
    @ObservedResults(ItemEntity.self) var items
    
    // MARK: - Root Properties
    // TODO: Try moving PosVM into POSView. Make sure cart isnt lost on view change
    @StateObject var posVM = PointOfSaleViewModel()
    @StateObject var lsxVM: LSXViewModel = LSXViewModel()
    @StateObject var rootVM = RootViewModel()
    
    @State var showOnboarding = false // For Dev
    
    @State var tabButtons: [TabButtonModel] = [
        TabButtonModel(destination: .settings, unselectedIconName: "line.3.horizontal.circle", selectedIconName: "line.3.horizontal.circle.fill", title: "Menu"),
        TabButtonModel(destination: .inventoryList, unselectedIconName: "tray.full", selectedIconName: "tray.full.fill", title: "Inventory"),
        TabButtonModel(destination: .pos, unselectedIconName: "dollarsign", selectedIconName: "dollarsign.circle.fill", title: "Make a Sale")
    ]
    
    var body: some View {
        if let company = companies.first, company.finishedOnboarding {
            GeometryReader { geo in
                let isLandscape: Bool = geo.size.width > geo.size.height
                
                NavigationStack(path: $navService.path) {
                    /// The VStack needs to be inside a ZStack in order for the POSView's sidebar to offset the TabBar's buttons.
                    ZStack {
                        VStack(spacing: 0) {
                            primaryContent
                                .background(Color.bg)
                            
                            // MARK: - Tab Bar
                            HStack {
                                Spacer()
                                
                                ForEach(tabButtons) { data in
                                    let isSelected = lsxVM.mainDisplay == data.destination
                                    Button {
                                        lsxVM.mainDisplay = data.destination
                                    } label: {
                                        VStack(spacing: 2) {
                                            Image(systemName: isSelected ? data.selectedIconName : data.unselectedIconName)
                                                .resizable()
                                                .scaledToFit()
                                            
                                            Text(data.title)
                                                .padding(4)
                                                .font(.caption2)
                                        } //: VStack
                                        .padding(.vertical, 2)
                                    }
                                    .opacity(isSelected ? 1 : 0.6)
                                    .frame(maxHeight: 48)
                                    Spacer()
                                } //: For Each
                                
                                if lsxVM.mainDisplay == .pos {
                                    Spacer()
                                        .frame(maxWidth: navService.sidebarWidth ?? 500)
                                        .ignoresSafeArea(edges: [.trailing])
                                }
                            } //: HStack
                            .frame(maxHeight: 56)
                            .background(Color.accentColor.opacity(0.007))
                            .padding(.bottom, geo.safeAreaInsets.bottom / 2)
                            .overlay(DividerX(), alignment: .top)
                        } //: VStack
                        .background(Color.bg)
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationDestination(for: LSXDisplay.self) { detail in
                            switch detail {
                            case .company:
                                CompanyDetailView(company: companies.first ?? CompanyEntity())
                                    
                                
                            case .item(let i):          ItemDetailView(item: i)
                            case .department(let d):    DepartmentDetailView(department: d)
                            case .confirmSale:
                                ConfirmSaleView()
                                    .environmentObject(posVM)
                                    .environment(navService)
                                
                            default: Color.red
                            }
                        }
                        .ignoresSafeArea(edges: [.bottom])
                        
                        if navService.sidebarWidth ?? 0 > 180 && lsxVM.mainDisplay == .pos {
                            CartSidebarView(vm: posVM)
                                .ignoresSafeArea(edges: [.top])
                                .padding(0)
                                .environmentObject(posVM)
                        }
                    } //: ZStack
                    .background(.bg)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            switch lsxVM.mainDisplay {
                            case .pos:
                                if navService.sidebarVisibility != nil {
                                    Button {
                                        navService.toggleSidebar()
                                    } label: {
                                        HStack(spacing: 4) {
                                            Image(systemName: "cart")
                                            Image(systemName: navService.sidebarVisibility == .hidden ? "chevron.backward.2" : "chevron.forward.2")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 16)
                                        }
                                    }
                                } else {
                                    Spacer()
                                }
                                
                            default: EmptyView()
                            }
                        }
                    }
                } //: Navigation Stack
//                .onChange(of: companies.first) { old, new in
//                    if new == nil {
//                        self.showOnboarding = true
//                    }
//                }
//                .onReceive(rootVM.$companyExists) { exists in
//                    print("Root: Company Received")
//                    //                    self.showOnboarding = !exists
//                }
                .onAppear {
//                    guard items.count > 0 && departments.count > 0 && companies.count > 0 else {
//                        self.showOnboarding = true
//                        return
//                    }
                    
                    if isLandscape && hSize == .regular {
                        navService.sidebarVisibility = .showing
                        // Set the width to 280 at most, ideally 1/3 of the screen's width and slightly less when on compact vertical size device.
                        navService.sidebarWidth = min(geo.size.width / 3 - (vSize == .compact ? 42 : 0), 280)
                    } else {
                        navService.sidebarVisibility = nil
                        navService.sidebarWidth = 0
                    }
                }
                .onChange(of: isLandscape) { _, isLandscape in
                    if isLandscape && hSize == .regular {
                        navService.sidebarVisibility = .showing
                        // Set the width to 280 at most, ideally 1/3 of the screen's width and slightly less when on compact vertical size device.
                        navService.sidebarWidth = min(geo.size.width / 3 - (vSize == .compact ? 42 : 0), 280)
                    } else {
                        navService.sidebarVisibility = nil
                        navService.sidebarWidth = 0
                    }
                }
                
                .environment(navService)
            }
        } else {
            OnboardingView()
                .environmentObject(lsxVM)
        }
    } //: Body
    
    @ViewBuilder var primaryContent: some View {
        switch lsxVM.mainDisplay {
        case .pos:
            HStack {
                POSView()
                    .environmentObject(posVM)
                    .tag(LSXDisplay.pos)
                Spacer()
                    .frame(maxWidth: navService.sidebarVisibility != .showing ? 0 : navService.sidebarWidth ?? 500)
            } //: HStack
            
        case .inventoryList:
            InventoryListView()
                .tag(LSXDisplay.inventoryList)
            
        case .settings:
            SettingsView()
                .tag(LSXDisplay.settings)
                .environmentObject(lsxVM)
            
        default: EmptyView()
        }
    }
    
//    @ViewBuilder var tabBarDivider: some View {
//        if lsxVM.mainDisplay.showsTabBarDivider {
//            Divider()
//                .background(Color.accentColor.opacity(0.01))
//        }
//    }
    
}

#Preview {
    TabRoot()
        .environment(\.realm, DepartmentEntity.previewRealm)
    //        .onAppear {
    //            Task {
    //                try await RealmActor().setUpForDebug()
    ////                        let h = AuthService.shared.hashString("1234")
    ////                        await AuthService.shared.savePasscode(hash: h)
    //                AuthService.shared.exists = true
    //
    //            }
    //        }
}



struct TabButtonModel: Identifiable {
    let id: UUID =  UUID()
    let destination: LSXDisplay
    let unselectedIconName: String
    let selectedIconName: String
    let title: String
}
