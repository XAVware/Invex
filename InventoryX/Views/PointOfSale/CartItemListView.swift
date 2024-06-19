//
//  CartItemListView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 5/21/24.
//

import SwiftUI

struct CartItemListView: View {
    @StateObject var vm: PointOfSaleViewModel
    @State var isEditable: Bool
    
    init(vm: PointOfSaleViewModel, isEditable: Bool) {
        self._vm = StateObject(wrappedValue: vm)
        self.isEditable = isEditable
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16) {
                ForEach(vm.uniqueItems) { item in
                    if isEditable {
                        VStack {
                            HStack {
                                Text(item.name)
                                Spacer()
                                Text(item.retailPrice.formatAsCurrencyString())
                                    .font(.subheadline)
                            } //: HStack
                            
                            HStack {
                                Text("x \(vm.cartItems.filter { $0._id == item._id }.count)")
                                
                                Spacer()
                            }
                        }
                        .frame(minHeight: 64, maxHeight: 96)
                        //                    Stepper("x \(vm.cartItems.filter { $0._id == item._id }.count)") {
                        //                        vm.addItemToCart(item)
                        //                    } onDecrement: {
                        //                        vm.removeItemFromCart(item)
                        //                    }
                        
                    } else {
                        let itemQty = vm.cartItems.filter { $0._id == item._id }.count
                        let itemSubtotal: Double = Double(itemQty) * item.retailPrice
                        HStack(spacing: 0) {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                Spacer()
                                Text("Qty: \(itemQty)")
                            } //: VStack
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text("\(item.retailPrice.formatAsCurrencyString()) / unit")
                                Spacer()
                                Text(itemSubtotal.formatAsCurrencyString())
                            } //: VStack
                        } //: HStack
                        .padding(.vertical, 8)
                        
                        Divider().opacity(0.4)
                    }
                } //: VStack
            } //: For Each
        } //: Scroll
        .frame(maxWidth: 420)
    }
}

#Preview {
    CartItemListView(vm: PointOfSaleViewModel(), isEditable: true)
}
