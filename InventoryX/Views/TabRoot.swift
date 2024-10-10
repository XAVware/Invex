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
}

struct TabRoot: View {
    @State private var navigationService: NavigationService = .init()
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var hSize
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
            NavigationStack(path: $navigationService.path) {
                VStack(spacing: 0) {
                    TabView(selection: $lsxVM.mainDisplay) {
                        POSView()
                            .environmentObject(posVM)
                            .tag(LSXDisplay.pos)
                        
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
                                VStack(spacing: 6) {
                                    Image(systemName: isSelected ? data.selectedIconName : data.unselectedIconName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 22)
                                    
                                    if hSize == .regular {
                                        Text(data.title)
                                            .padding(4)
                                            .font(.caption2)
                                    }
                                } //: VStack
                            }
                            .opacity(isSelected ? 1 : 0.6)
                            
                            Spacer()
                        } //: For Each
                        
                    } //: HStack
                    .padding(.bottom, 4)
                } //: VStack
                .environment(navigationService)
                //            .padding(.vertical)
                .background(Color.bg)
                .navigationDestination(for: LSXDisplay.self) { detail in
                    switch detail {
                    case .company:                  CompanyDetailView()
                    case .passcodePad(let p):       PasscodeView(processes: p) { }
                    case .item(let i, let t):       ItemDetailView(item: i, detailType: t)
                    case .department(let d, let t): DepartmentDetailView(department: d, detailType: t)
                    case .confirmSale(let items):   ConfirmSaleView(cartItems: items)
                    default: Color.red
                    }
                }
            } //: Navigation Stack
            .onReceive(rootVM.$companyExists) { exists in
                print("Root: Company Received")
                //                self.showOnboarding = !exists
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
