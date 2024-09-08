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
 
 */

struct TabRoot: View {
    @Environment(\.dismiss) var dismiss
    // MARK: - Root Properties
    // TODO: Try moving PosVM into POSView. Make sure cart isnt lost on view change
    @StateObject var posVM = PointOfSaleViewModel()
    @StateObject var lsxVM: LSXViewModel = LSXViewModel()
    @StateObject var rootVM = RootViewModel()

    //    @State var showOnboarding: Bool? = nil // For production
    @State var showOnboarding = false // For Dev
    @State var mainDisplay: LSXDisplay = .company
    
    
    // This could be causing lock screen to dismiss on orientation change.
    @State var showingLockScreen: Bool = false
    
    
    var body: some View {
        switch showOnboarding {
        case true:
            OnboardingView()
                .environmentObject(lsxVM)
            
        case false:
            NavigationStack(path: $lsxVM.primaryPath) {
                TabView(selection: $mainDisplay) {
                    POSView()
                        .environmentObject(posVM)
                        .tabItem {
                            Text("Make A Sale")
                        }
                        .tag(LSXDisplay.pos.tabId)
                    
                    InventoryListView()
                        .tabItem {
                            Text("Inventory")
                        }
                        .tag(LSXDisplay.inventoryList.tabId)
                    
                    SettingsView()
                        .tabItem {
                            Text("Settings")
                        }
                        .tag(LSXDisplay.settings.tabId)
                        
                }
                .navigationDestination(for: LSXDisplay.self) { detail in
                    switch detail {
                    case .confirmSale(let items):   ConfirmSaleView(cartItems: items)
                    case .item(let i, let t):       ItemDetailView(item: i, detailType: t)
                    case .department(let d, let t): DepartmentDetailView(department: d, detailType: t)
                    default: Color.red
                    }
                }
                .tint(Color.accentColor)
                .fullScreenCover(isPresented: $showingLockScreen) {
                    LockScreenView()
                        .frame(maxHeight: .infinity)
                        .background(Color.bg)
                }
                .onChange(of: mainDisplay) { _, display in
                    if display == .lock {
                        showingLockScreen = true
                    }
                }
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

