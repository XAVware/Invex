//
//  CartTotalsView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 11/4/24.
//

import SwiftUI

struct CartTotalsView: View {
    @EnvironmentObject var vm: PointOfSaleViewModel
    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Text("Subtotal:")
                Spacer()
                Text("\(vm.cartSubtotal.toCurrencyString())")
            } //: HStack
            
            HStack {
                Text("Tax:")
                Spacer()
                Text("\(vm.taxAmount.toCurrencyString())")
            } //: HStack
        } //: VStack
        .font(.subheadline)
        .padding()
    }
}

#Preview {
    CartTotalsView()
}
