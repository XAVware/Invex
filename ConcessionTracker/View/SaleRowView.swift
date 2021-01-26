//
//  SaleRowView.swift
//  InventoryV2
//
//  Created by Ryan Smetana on 12/27/20.
//

import SwiftUI

struct SaleRowView: View {
    @State var isExpanded: Bool     = false
    @State var sale: Sale
    
    var body: some View {
        GroupBox {
            DisclosureGroup(isExpanded: self.$isExpanded) {
                VStack {
                    Divider().padding(.vertical, 8)
                    Text("Items: ")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack {
                        ForEach(self.sale.items, id: \.self) { saleItem in
                            HStack {
                                Image(systemName: "circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 10, height: 10)
                                
                                Text("\(saleItem.name) \(saleItem.subtype == "" ? "x\(saleItem.qtyToPurchase)" : "- \(saleItem.subtype) x\(saleItem.qtyToPurchase)")")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            } label: {
                Button(action: {
                    withAnimation {
                        self.isExpanded.toggle()
                    }
                }) {
                    HStack {
                        Text("\(self.formatDate(date: sale.timestamp))")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("$\(String(format: "%.2f", sale.total))")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    
                }
            } //: DisclosureGroup
        }
        .padding(.horizontal)
    }
    
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM. d y 'at' h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        return dateFormatter.string(from: date)
    }
}
