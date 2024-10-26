//
//  PointOfSaleView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/26/24.
//

import SwiftUI
import RealmSwift
import Algorithms

/*
 8.29.24 - A warning is being thrown for breaking constraints on startup on regular width devices. I thought it was related to POSView but it only happens when OnboardingView is being displayed as a full screen cover. Going to toggle onboarding with an optional isOnboarding variable in the root.
 */

enum SidebarState {
    case hidden
    case showing
}

struct POSView: View {
    @Environment(NavigationService.self) var navService
    @Environment(\.horizontalSizeClass) var hSize
    @Environment(\.verticalSizeClass) var vSize
    
    @EnvironmentObject var vm: PointOfSaleViewModel
    
    @ObservedResults(ItemEntity.self) var items
    @ObservedResults(DepartmentEntity.self) var departments
    
    /// When `selectedDepartment` is nil, the app displays all items in the view.
    @State var selDept: DepartmentEntity?
    
    //    @Binding var cartItems: Binding<[CartItem]> = []
    
    var body: some View {
        HStack {
            VStack(spacing: 0) {
                // MARK: - Department Picker
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        Button {
                            selDept = nil
                        } label: {
                            Text("All")
                                .modifier(DepartmentButtonMod(isSelected: selDept == nil))
                        }
                        
                        ForEach(departments) { department in
                            Button {
                                selDept = department
                            } label: {
                                Text(department.name)
                                    .modifier(DepartmentButtonMod(isSelected: selDept == department))
                            }
                        } //: For Each
                    } //: HStack
                } //: Scroll View
                .padding(vSize == .regular ? 12 : 8)
                
                ItemGridView(items: selDept != nil ? Array(selDept?.items ?? .init()) : Array(items)) { item in
                    vm.addItemToCart(CartItem(from: item))
                }
            } //: VStack
            .padding(.horizontal, hSize == .regular ? 12 : 4)
            .animation(.interpolatingSpring, value: true)
            
            Spacer()
                .frame(maxWidth: navService.sidebarVisibility != .showing ? 0 : navService.sidebarWidth ?? 500)
            
        } //: HStack
        .overlay(navService.sidebarVisibility == nil ? checkoutButton : nil, alignment: .bottom)
        .background(.bg)
//        .background(.fafafa)
        .navigationTitle("Make a sale")
        .ignoresSafeArea(edges: [.bottom, .trailing])
        
    } //: Body
    
    private var checkoutButton: some View {
        PrimaryOverlayButton(action: {
            vm.checkoutTapped {
                navService.path.append(LSXDisplay.confirmSale(vm.cartItems))
            }
        }) {
            HStack {
                Image(systemName: "cart")
                Text("Checkout")
                Spacer()
                Text(vm.total.formatAsCurrencyString())
            }
        }
    }
    
}

struct PrimaryOverlayButton<Label: View>: View {
    let action: () -> Void
    let label: Label
    
    init(action: @escaping () -> Void, @ViewBuilder label: () -> Label) {
        self.action = action
        self.label = label()
    }
    
    var body: some View {
        Button(action: action) {
            label
                .padding(.horizontal, 4)
                .frame(maxWidth: 320, maxHeight: 26)
        }
        .font(.subheadline)
        .fontWeight(.semibold)
        .fontDesign(.rounded)
        .buttonStyle(ThemeButtonStyle())
        //        .padding()
        .shadow(radius: 1.5)
        
    }
}

#Preview {
    POSView()
        .environmentObject(PointOfSaleViewModel())
        .environment(\.realm, DepartmentEntity.previewRealm)
}
