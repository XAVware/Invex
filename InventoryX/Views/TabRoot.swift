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
    
    // MARK: - Root Properties
    // TODO: Try moving PosVM into POSView. Make sure cart isnt lost on view change
    @StateObject var posVM = PointOfSaleViewModel()
    @StateObject var lsxVM: LSXViewModel = LSXViewModel()
    @StateObject var rootVM = RootViewModel()
    
    @State var showOnboarding = false // For Dev
    
    @State var tabButtons: [TabButtonModel] = [
        TabButtonModel(destination: .inventoryList, unselectedIconName: "tray.full", selectedIconName: "tray.full.fill", title: "Inventory"),
        TabButtonModel(destination: .pos, unselectedIconName: "dollarsign", selectedIconName: "dollarsign.circle.fill", title: "Make a Sale"),
        TabButtonModel(destination: .settings, unselectedIconName: "person", selectedIconName: "person.fill", title: "Account")
    ]
    
    
    var body: some View {
        switch showOnboarding {
        case true:
            OnboardingView()
                .environmentObject(lsxVM)
            
        case false:
            NavigationStack(path: $navService.path) {
                GeometryReader { geo in
                    let isLandscape: Bool = geo.size.width > geo.size.height
                    ZStack {
                        VStack(spacing: 0) {
                            TabView(selection: $lsxVM.mainDisplay) {
                                POSView()
                                    .environmentObject(posVM)
                                    .tag(LSXDisplay.pos)
                                    .onAppear {
                                        if isLandscape && hSize == .regular {
                                            navService.sidebarVisibility = .showing
                                            navService.sidebarWidth = min(geo.size.width / 3, 320)
                                        } else {
                                            navService.sidebarVisibility = nil
                                            navService.sidebarWidth = 0
                                        }
                                    }
                                    .onChange(of: isLandscape) { _, isLandscape in
                                        if isLandscape && hSize == .regular {
                                            navService.sidebarVisibility = .showing
                                            navService.sidebarWidth = min(geo.size.width / 3, 320)
                                        } else {
                                            navService.sidebarVisibility = nil
                                            navService.sidebarWidth = 0
                                        }
                                    }
                                
                                InventoryListView()
                                    .tag(LSXDisplay.inventoryList)
                                
                                SettingsView()
                                    .tag(LSXDisplay.settings)
                                
                            } //: Tab
                            .tabViewStyle(.page(indexDisplayMode: .never))
                            .tint(Color.accentColor)
                            
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
//                                                .frame(height: 21)
                                            
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
                                
                                Spacer()
                                    .frame(maxWidth: navService.sidebarVisibility != nil ? navService.sidebarWidth ?? 320 : 0)
                                    .ignoresSafeArea(edges: [.trailing])
                            } //: HStack
                            .frame(maxHeight: 56)
                            .background(Color.accentColor.opacity(0.007))
                            .padding(.bottom, geo.safeAreaInsets.bottom / 2)
                        } //: VStack
                        .background(Color.bg)
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationDestination(for: LSXDisplay.self) { detail in
                            switch detail {
                            case .company:                  CompanyDetailView()
                            case .passcodePad(let p):       PasscodeView(processes: p) { }
                            case .item(let i, let t):       ItemDetailView(item: i, detailType: t)
                            case .department(let d, let t): DepartmentDetailView(department: d, detailType: t)
                            case .confirmSale(let items):
                                ConfirmSaleView(/*cartItems: items*/)
                                    .environmentObject(posVM)
                                    .environment(navService)
                            default: Color.red
                            }
                        }
                        .onAppear {
                            navService.sidebarVisibility = hSize == .regular ? .showing : nil
                        }
                        .ignoresSafeArea(edges: [.bottom])
                        
                        if navService.sidebarWidth ?? 0 > 180 && lsxVM.mainDisplay == .pos {
                            CartSidebarView(vm: posVM)
                                .ignoresSafeArea(edges: [.top])
                                .padding(.trailing, geo.safeAreaInsets.trailing == 0 ? 4 : 0)
                                .environmentObject(posVM)
                        }
                    } //: ZStack
                    .environment(navService)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            if navService.sidebarVisibility != nil {
                                Button("", systemImage: "chevron.forward.2", action: navService.toggleSidebar)
                            } else {
                                Spacer()
                            }
                        }
                    }
                } //: Navigation Stack
                .onReceive(rootVM.$companyExists) { exists in
                    print("Root: Company Received")
                    //                self.showOnboarding = !exists
                }
                
            }
        default: ProgressView()
        }
    } //: Body
    
    
    
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
