//
//  CartItemView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 9/4/24.
//

import SwiftUI
import RealmSwift

struct CartItem: Identifiable, Hashable {
    var id: ObjectId
    var name: String
    var attribute: String
    var retailPrice: Double
    var qtyInCart: Int
    
    init(from itemEntity: ItemEntity) {
        self.id = itemEntity._id
        self.name = itemEntity.name
        self.attribute = itemEntity.attribute
        self.retailPrice = itemEntity.retailPrice
        self.qtyInCart = 1
    }
    
    func convertToSaleItem() -> SaleItemEntity {
        return SaleItemEntity(item: self)
    }
    
}

struct CartItemView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var vm: PointOfSaleViewModel

    @State var item: CartItem
    let qty: Int
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text(item.name)
                    Text(item.attribute)
                        .font(.caption)
                } //: VStack
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text($item.wrappedValue.retailPrice.toCurrencyString())
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
                
                vm.adjustStock(of: item, by: -1)
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
            
//            Text("\(vm.cartItems.filter { $0._id == item._id }.count)")
            Text(qty.description)
                .frame(width: 42, height: 28, alignment: .center)
                .font(.subheadline)
                .background(.fafafa)
            
            
            Button {
//                vm.addItemToCart(item)
                vm.adjustStock(of: item, by: 1)
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
        .listRowBackground(Color.clear)

    }
}


//#Preview {
//    CartItemView(ItemEntity.item1)
//}
