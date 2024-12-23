//
//  CartView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 4/9/24.
//

import SwiftUI
import RealmSwift

struct CartSidebarView: View {
    @Environment(\.verticalSizeClass) var vSize
    @Environment(NavigationService.self) var navService
    
    @StateObject var vm: PointOfSaleViewModel
    
    init(vm: PointOfSaleViewModel) {
        self._vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                Spacer()
                VStack {
                    Text("Cart")
                        .font(.system(.callout, design: .rounded, weight: .medium))
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 54)
                    
                    List(vm.cartItems) { item in
                        CartItemView(item: item, qty: item.qtyInCart)
                            .listRowBackground(Color.clear)
                            .padding(.vertical, 8)
                    }
                    .frame(maxHeight: .infinity)
                    .listStyle(PlainListStyle())
                    .environmentObject(vm)
                    
                    // MARK: - Cart Totals
                    CartTotalsView()
                        .padding()
                    
                    // Height should be bottom safe area plus tab bar height - if its ignoring safe areas
                    Spacer()
                        .frame(height: geo.safeAreaInsets.bottom + (vSize == .compact ? 32 : 48))
                } //: VStack
                .background(Color.bg.ignoresSafeArea(edges: .trailing))
                .overlay(DividerX(), alignment: .leading)
                .frame(maxWidth: navService.sidebarWidth ?? 500)
                .offset(x: navService.sidebarVisibility != .showing ? navService.sidebarWidth ?? 500 : 0)
                .alert("Your cart is empty.", isPresented: $vm.showCartAlert) {
                    Button("Okay", role: .cancel) { }
                }
            } //: HStack
            .overlay(navService.sidebarVisibility != nil ? checkoutButton.padding(.bottom, geo.safeAreaInsets.bottom / 2) : nil, alignment: .bottomTrailing)
            .ignoresSafeArea(edges: .bottom)
        }
    } //: Body
    
    
    private var checkoutButton: some View {
        Button {
            vm.checkoutTapped {
                navService.path.append(LSXDisplay.confirmSale)
            }
        } label: {
            HStack {
                Text("Checkout")
                Spacer()
                Text(vm.total.toCurrencyString())
                    .fontWeight(.semibold)
            }
            .font(.system(.callout, design: .rounded))
            .padding(8)
            .padding(.horizontal, 12)
            .frame(maxWidth: navService.sidebarWidth ?? 320, maxHeight: 48)
        }
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.accent.gradient)
                .padding(.horizontal, 8)
        )
        .foregroundColor(Color.primaryButtonText)
        .padding(.vertical, vSize == .regular ? 2 : 0)
    }
    
}

//#Preview {
//    HStack {
//        CartSidebarView(vm: PointOfSaleViewModel(), ignoresTopBar: false)
//            .environment(\.realm, DepartmentEntity.previewRealm)
//            .frame(maxWidth: 360, alignment: .leading)
//
//        Spacer()
//    }
//}
