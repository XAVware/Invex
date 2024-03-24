//
//  SaleDetailView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 6/2/23.
//

import SwiftUI
import RealmSwift

struct SaleDetailView: View {
    @Environment(\.dismiss) var dismiss
    @State var sale: SaleEntity
    
    private func getSubtotal(item: SaleItemEntity) -> Double {
        let price: Double = item.unitPrice
        let quantity: Double = Double(item.qtyToPurchase)
        return price * quantity
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Sale Details")
                .modifier(TextMod(.largeTitle, .semibold, .black))
                .frame(maxWidth: .infinity)
                .padding(.top)
            
            Divider()
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Cashier:")
                        .modifier(TextMod(.title2, .semibold, .gray))
                    
                    Text(sale.cashierName)
                        .modifier(TextMod(.title2, .regular, .black))
                } //: VStack
                Spacer()
                    
                VStack(alignment: .leading) {
                    Text("Timestamp:")
                        .modifier(TextMod(.title2, .semibold, .gray))
                    
                    Text(sale.timestamp.formatted(date: .abbreviated, time: .shortened))
                        .modifier(TextMod(.title2, .regular, .black))
                }
            } //: HStack
            .padding()
            
            HStack(spacing: 16) {
                Text("Total:")
                    .modifier(TextMod(.title, .semibold, .gray))
                
                Text(sale.total.formatAsCurrencyString())
                    .modifier(TextMod(.title, .regular, .black))
            } //: HStack
            
            VStack(spacing: 0) {
                HStack {
                    Text("Item Name:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Quantity Sold:")
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Text("Item Price:")
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Text("Item Subtotal:")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                } //: HStack
                .frame(height: 50)
                .padding(.horizontal)
                .modifier(TextMod(.body, .regular, .black))
                .background(Theme.secondaryBackground)
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(sale.items.indices, id: \.self) { index in
                        HStack(spacing: 0) {
                            Text(sale.items[index].name)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Divider()

                            Text("\(sale.items[index].qtyToPurchase)")
                                .frame(maxWidth: .infinity, alignment: .center)

                            Divider()

                            Text(sale.items[index].unitPrice.formatAsCurrencyString())
                                .frame(maxWidth: .infinity, alignment: .center)

                            Divider()

                            Text(getSubtotal(item: sale.items[index]).formatAsCurrencyString())
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        } //: HStack
                        .frame(height: 50)
                        .padding(.horizontal)
                        .background(index % 2 == 0 ? Theme.lightFgColor : Theme.secondaryBackground)
                        .modifier(TextMod(.body, .regular, .black))
                    } //: ForEach
                } //: ScrollView
            } //: VStack
            .padding(.top)
            
            Spacer()
        } //: VStack
        .overlay(
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                    .foregroundColor(.black)
            }
            .padding()
            , alignment: .topLeading)
        .background(Theme.lightFgColor)
    } //: Body
    
}


struct SaleDetailView_Previews: PreviewProvider {
    @State static var sale: SaleEntity = SaleEntity.todaySale1
    static var previews: some View {
        SaleDetailView(sale: sale)
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (4th generation)"))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
