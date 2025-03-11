//
//  CartItemView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 9/4/24.
//

import SwiftUI
import RealmSwift

struct CartItemView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var vm: PointOfSaleViewModel
    
    @State var item: CartItem
    let qty: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.headline)
                    if !item.attribute.isEmpty {
                        Text(item.attribute)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.subheadline)
                            .fontWeight(.light)
                    }
                    Spacer()
                } //: VStack
                
                stepper
            } //: VStack
            
            VStack(alignment: .trailing, spacing: 2) {
                VStack(alignment: .trailing, spacing: 2) {
                    let price = $item.wrappedValue.retailPrice
                    Text((price * Double(qty)).toCurrencyString())
                        .fontWeight(.semibold)
                    Text(price.toCurrencyString() + " ea.")
                        .font(.caption2)
                    Spacer()
                }
                
                Button("Remove", systemImage: "trash") {
                    vm.removeItemFromCart(withId: item.id)
                }
                .labelStyle(.iconOnly)
                .buttonStyle(.plain)
                .font(.callout)
                .fontWeight(.light)
                .opacity(0.8)
            } //: VStack
            .frame(maxWidth: 72, alignment: .trailing)
        } //: HStack
        .fontDesign(.rounded)
        .frame(maxHeight: 240)
    } //: Body
    
    private var stepper: some View {
        HStack(spacing: 0) {
            Button {
                vm.adjustStock(of: item, by: -1)
            } label: {
                Text("-")
                    .font(.system(.title2, design: .rounded, weight: .light))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .background(Color.bg400)
            }
            .frame(width: 26, height: 28, alignment: .center)
            .buttonStyle(PlainButtonStyle())
            .disabled(qty == 0)
            
            Text(qty.description)
                .frame(width: 42, height: 28, alignment: .center)
                .font(.subheadline)
                .background(Color.bg100)
            
            
            Button {
                vm.adjustStock(of: item, by: 1)
            } label: {
                Text("+")
                    .font(.system(.title2, design: .rounded, weight: .light))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .background(Color.bg400)
            }
            .frame(width: 26, height: 28, alignment: .center)
            .buttonStyle(PlainButtonStyle())
        } //: HStack
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.shadow100, lineWidth: 0.5))
        
    }
}


#Preview {
    CartItemView(item: CartItem(from: ItemEntity.item1), qty: 2)
        .padding()
        .environmentObject(PointOfSaleViewModel())
}
