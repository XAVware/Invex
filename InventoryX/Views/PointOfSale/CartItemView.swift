//
//  CartItemView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 9/4/24.
//

import SwiftUI

struct CartItem: Identifiable {
//    let id: UUID
//    let name: String
//    let attribute: String
//    let price: Double
    var id: UInt64 { return item.id }
    let item: ItemEntity
    @State var qtyInCart: Int
}

struct CartItemView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var vm: PointOfSaleViewModel
    @State var item: ItemEntity
    
    init(_ item: ItemEntity) {
        self.item = item
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(alignment: .center) {
                // MARK: - Item Name & Attribute
                VStack(alignment: .leading) {
                    Text(item.name)
                    Text(item.attribute)
                        .font(.caption)
                } //: VStack
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(item.retailPrice.formatAsCurrencyString())
                    .font(.callout)
            } //: HStack
            
            HStack {
                Spacer()
                stepper
            } //: HStack
        } //: VStack
        .padding(.vertical, 6)
    } //: Body
    
    private var stepper: some View {
        HStack(spacing: 0) {
            Button {
                vm.removeItemFromCart(item)
            } label: {
                Text("-")
                    .font(.title2)
                    .fontWeight(.light)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .background(.bg)
            }
            .frame(width: 26, height: 28, alignment: .center)
            .buttonStyle(PlainButtonStyle())
            .blendMode(colorScheme == .dark ? .plusLighter : .plusDarker)
            
            Text("\(vm.cartItems.filter { $0._id == item._id }.count)")
                .frame(width: 42, height: 28, alignment: .center)
                .font(.subheadline)
                .background(.white)
            
            Button {
                vm.addItemToCart(item)
            } label: {
                Text("+")
                    .font(.title2)
                    .fontWeight(.light)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .background(.bg)
            }
            .frame(width: 26, height: 28, alignment: .center)
            .buttonStyle(PlainButtonStyle())
            .blendMode(colorScheme == .dark ? .plusLighter : .plusDarker)
        } //: HStack
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.neoOverDark, lineWidth: 0.5))
    }
}


#Preview {
    CartItemView(ItemEntity.item1)
}
