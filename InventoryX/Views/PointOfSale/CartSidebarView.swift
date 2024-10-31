//
//  CartView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 4/9/24.
//

import SwiftUI
import RealmSwift

struct CartSidebarView: View {
    @Environment(NavigationService.self) var navService

    @StateObject var vm: PointOfSaleViewModel

    init(vm: PointOfSaleViewModel) {
        self._vm = StateObject(wrappedValue: vm)
    }

    var body: some View {
        HStack {
            Spacer()
            ZStack {
                NeomorphicCardView(layer: .under, cornerRadius: 8)
                
                VStack {
                    Spacer().frame(height: 54)
//                    HStack {
//                        Image(systemName: "cart")
//                        Text("Cart")
//                            .padding(.horizontal)
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                    }
//                    .padding([.top, .horizontal])
//                    .font(.headline)
//                    .foregroundStyle(.accent)
//                    .opacity(0.8)
                    
//                    Text("Items")
                    
                    List(vm.cartItems) { item in
                        CartItemView(item: item, qty: item.qtyInCart)
                            .listRowBackground(Color.clear)
                            .environmentObject(vm)
                    }
                    .frame(maxHeight: .infinity)
                    .listStyle(PlainListStyle())
                    
                    // MARK: - Cart Totals
                    VStack(spacing: 4) {
                        HStack {
                            Text("Subtotal:")
                            Spacer()
                            Text("\(vm.cartSubtotal.formatAsCurrencyString())")
                        } //: HStack
                        
                        HStack {
                            Text("Tax:")
                            Spacer()
                            Text("\(vm.taxAmount.formatAsCurrencyString())")
                        } //: HStack
                    } //: VStack
                    .font(.subheadline)
                    .padding()
                    
                    Spacer()
                        .frame(height: 48)
                } //: VStack
                .alert("Your cart is empty.", isPresented: $vm.showCartAlert) {
                    Button("Okay", role: .cancel) { }
                }
                
            } //: ZStack
            .frame(maxWidth: navService.sidebarWidth ?? 500)
            .offset(x: navService.sidebarVisibility != .showing ? navService.sidebarWidth ?? 500 : 0)
        } //: HStack
        .overlay(navService.sidebarVisibility != nil ? checkoutButton : nil, alignment: .bottomTrailing)
    } //: Body

    private var checkoutButton: some View {
        Button {
            vm.checkoutTapped {
                navService.path.append(LSXDisplay.confirmSale(vm.cartItems))
            }
        } label: {
            HStack {
//                Image(systemName: "cart")
                Text("Checkout")
                Spacer()
                Text(vm.total.formatAsCurrencyString())
            }
            .padding(6)
            .padding(.horizontal, 10)
            .frame(maxWidth: navService.sidebarWidth ?? 320, maxHeight: 56)
        }
        .font(.subheadline)
        .fontWeight(.semibold)
        .fontDesign(.rounded)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color.accent.gradient)
                .padding(2)
        )
        .foregroundColor(Color.primaryButtonText)
        .shadow(radius: 1)
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
