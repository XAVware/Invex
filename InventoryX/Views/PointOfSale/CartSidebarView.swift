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
    
    init(vm: PointOfSaleViewModel, ignoresTopBar: Bool) {
        self._vm = StateObject(wrappedValue: vm)
        self.ignoresTopBar = ignoresTopBar
    }
    
    func continueTapped() {
        if vm.cartItems.isEmpty {
            showCartAlert.toggle()
        } else {
            LazySplitService.shared.pushPrimary(.confirmSale)
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
                        Text("Tax: (\((vm.taxRate * 100).toPercentageString())%)")
                        Spacer()
                        Text("\(vm.taxAmount.formatAsCurrencyString())")
                    } //: HStack
                    
                    HStack {
                        Text("Total:")
                        Spacer()
                        Text(vm.total.formatAsCurrencyString())
                    } //: HStack
                    .fontWeight(.semibold)
                    
                } //: VStack
                .font(.subheadline)
                .padding(8)
                
                
                Button {
                    continueTapped()
                } label: {
                    Spacer()
                    Text("Checkout")
                    Spacer()
                }
                .modifier(PrimaryButtonMod())
                
                
            } //: VStack
            
        } //: VStack
        .alert("Your cart is empty.", isPresented: $showCartAlert) {
            Button("Okay", role: .cancel) { }
        }
        .padding()
        .background(.ultraThinMaterial)
        .onAppear {
            vm.fetchCompany()
        }
    } //: Body
    
}

#Preview {
    HStack {
        CartSidebarView(vm: PointOfSaleViewModel(), ignoresTopBar: false)
            .environment(\.realm, DepartmentEntity.previewRealm)
            .frame(maxWidth: 360, alignment: .leading)

        Spacer()
    }
}
