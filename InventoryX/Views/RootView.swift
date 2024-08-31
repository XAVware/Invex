//
//  RootView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/19/24.
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

struct RootView: View {
    @Environment(\.horizontalSizeClass) var hSize
    @StateObject var lsxVM: LSXViewModel = LSXViewModel()
    @StateObject var posVM = PointOfSaleViewModel()
    @StateObject var rootVM = RootViewModel()
    
    @State var showCartAlert: Bool = false
    @State var showOnboarding: Bool? = nil
    
    var body: some View {
        content
            .onReceive(rootVM.$companyExists) { exists in
                print("Root: Company Received")
                self.showOnboarding = !exists
            }
        
    } //: Body
    
    @ViewBuilder private var content: some View {
        switch showOnboarding {
        case true:
            OnboardingView()
                .environmentObject(lsxVM)
            
        case false:
            LSXView(viewModel: lsxVM) {
                MenuView()
            } content: {
                switch lsxVM.mainDisplay {
                case .pos:
                    POSView()
                        .toolbar {
                            // Only show cart toolbar button when menu isn't open
                            if lsxVM.prefCol != .sidebar {
                                ToolbarItem(placement: .topBarTrailing) {
                                    Button {
                                        switch hSize {
                                        case .compact:
                                            // On Compact, push confirm sale view with the cart items.
                                            guard !posVM.cartItems.isEmpty else {
                                                showCartAlert.toggle()
                                                return
                                            }
                                            LSXService.shared.update(newDisplay: .confirmSale)
                                            
                                        case .regular:
                                            // Toggle between sidebar and hidden display mode.
                                            if posVM.cartDisplayMode == .hidden {
                                                posVM.showCartSidebar()
                                            } else {
                                                posVM.hideCartSidebar()
                                            }
                                            
                                        default: print("Invalid horizontal size class.")
                                        }
                                    } label: {
                                        HStack(spacing: 12) {
                                            Text("\(posVM.cartItems.count)")
                                            Image(systemName: "cart")
                                                .frame(width: 18, height: 18)
                                        }
                                        .padding(8)
                                        .padding(.horizontal, 4)
                                        .font(.callout)
                                        .foregroundStyle(Color.white)
                                        .background(Color.accent.opacity(0.95))
                                        .clipShape(Capsule())
                                    }
                                    
                                }
                            }
                        }
                case .inventoryList:    InventoryListView()
                case .settings:         SettingsView()
                default:                EmptyView()
                }
            } detail: {
                switch lsxVM.detailRoot {
                case .item(let i, let t):       ItemDetailView(item: i, detailType: t)
                case .department(let d, let t): DepartmentDetailView(department: d, detailType: t)
                case .company(let c, let t):    CompanyDetailView(company: c, detailType: t)
                case .passcodePad(let p):       PasscodeView(processes: p) { }
                default:                        EmptyView()
                }
            } //: LSX View
            .alert("Your cart is empty.", isPresented: $showCartAlert) {
                Button("Okay", role: .cancel) { }
            }
            .environmentObject(posVM)
            .onAppear {
                print("Root: On Appear")
                // Setup cart sidebar
                switch hSize {
                case .regular:  posVM.showCartSidebar()
                default:        posVM.hideCartSidebar()
                }
            }
            .onChange(of: hSize) { _, hSize in
                print("Root: On Change - hSize")
                switch hSize {
                case .regular:  posVM.showCartSidebar()
                default:        posVM.hideCartSidebar()
                }
            }
            
        default:
            ProgressView()
        }
    }
    
    
}

#Preview {
    RootView()
        .environment(\.realm, DepartmentEntity.previewRealm)
}
