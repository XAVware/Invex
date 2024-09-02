//
//  CartView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 4/9/24.
//

import SwiftUI
import RealmSwift

struct CartSidebarView: View {
    @StateObject var vm: PointOfSaleViewModel
    @State var ignoresTopBar: Bool
    @State var showCartAlert: Bool = false
    let width: CGFloat
    
    init(vm: PointOfSaleViewModel, ignoresTopBar: Bool, width: CGFloat) {
        self._vm = StateObject(wrappedValue: vm)
        self.ignoresTopBar = ignoresTopBar
        self.width = width
    }
    
    func continueTapped() {
        if vm.cartItems.isEmpty {
            showCartAlert.toggle()
        } else {
            LSXService.shared.update(newDisplay: .confirmSale)
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            CartItemListView(vm: vm, isEditable: true)
                .padding(.top, ignoresTopBar ? 48 : 0)
            
            VStack(alignment: .leading, spacing: 16) {
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
                    
//                    HStack {
//                        Text("Total:")
//                        Spacer()
//                        Text(vm.total.formatAsCurrencyString())
//                    } //: HStack
//                    .fontWeight(.semibold)
                    
                } //: VStack
                .font(.subheadline)
                .padding(8)
                
                Button(action: continueTapped) {
                    VStack(spacing: 4) {
                        HStack {
                            Text("Checkout")
//                                .frame(maxWidth: .infinity)
                            Text(vm.total.formatAsCurrencyString())
                        }
                        .frame(maxWidth: .infinity)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        
//                        Text("\(vm.cartItems.count.description) items")
//                            .font(.caption2)
                    }
                    .fontDesign(.rounded)
                }
                .buttonStyle(ThemeButtonStyle())
                
            } //: VStack
            
        } //: VStack
        .alert("Your cart is empty.", isPresented: $showCartAlert) {
            Button("Okay", role: .cancel) { }
        }
        .padding(.trailing, 8)
        .background(.bg)
        //TODO: Company data doesn't need to be fetched every time this appears. Just save it in POS VM
        .onAppear {
            vm.fetchCompany()
        }
        .frame(maxWidth: width)
        .offset(x: vm.cartDisplayMode == .hidden ? width : 0)
        .ignoresSafeArea()
    } //: Body
    
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
