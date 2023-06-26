//
//  ItemDetailView.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 5/2/23.
//

import SwiftUI

struct ItemDetailView: View {
    @Binding var selectedItem: InventoryItemEntity?
    
    var body: some View {
        if selectedItem == nil {
            AddItemView()
        } else {
            VStack(spacing: 16) {
                Text("Item Details")
                    .modifier(TextMod(.title, .semibold))
                    .padding(.bottom)
                
                HStack {
                    VStack(spacing: 8) {
                        Text("Item Name")
                            .modifier(TextMod(.title3, .regular))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Lays")
                            .modifier(TextMod(.title, .semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } //: VStack
                    
                    VStack(spacing: 8) {
                        Text("Category")
                            .modifier(TextMod(.title3, .regular))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Food")
                            .modifier(TextMod(.title, .semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } //: VStack
                } //: HStack
                .padding(.horizontal)
                
                VStack {
                    Divider()
                    Divider()
                } //: VStack
                .padding(.vertical)
                
                HStack {
                    VStack(spacing: 8) {
                        Text("Retail Price")
                            .modifier(TextMod(.title3, .regular))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("$1.00")
                            .modifier(TextMod(.title, .semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } //: VStack
                    
                    VStack(spacing: 8) {
                        Text("Unit Cost")
                            .modifier(TextMod(.title3, .regular))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("$0.50")
                            .modifier(TextMod(.title, .semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } //: VStack
                } //: HStack
                .padding(.horizontal)
                
                HStack {
                    VStack(spacing: 8) {
                        Text("Markup (%)")
                            .modifier(TextMod(.title3, .regular))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("100%")
                            .modifier(TextMod(.title, .semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } //: VStack
                    
                    VStack(spacing: 8) {
                        Text("Margin (%)")
                            .modifier(TextMod(.title3, .regular))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("50%")
                            .modifier(TextMod(.title, .semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } //: VStack
                } //: HStack
                .padding(.horizontal)
                
                VStack {
                    Divider()
                    Divider()
                } //: VStack
                .padding(.vertical)
                
                HStack {
                    VStack(spacing: 8) {
                        Text("On-Hand Qty.")
                            .modifier(TextMod(.title3, .regular))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("42")
                            .modifier(TextMod(.title, .semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } //: VStack
                    
                    VStack(spacing: 8) {
                        Text("Sales Today")
                            .modifier(TextMod(.title3, .regular))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("12")
                            .modifier(TextMod(.title, .semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } //: VStack
                } //: HStack
                .padding(.horizontal)
                
                HStack {
                    Spacer()
                        .frame(maxWidth: .infinity)
                    
                    VStack(spacing: 8) {
                        Text("Total Sales")
                            .modifier(TextMod(.title3, .regular))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("478")
                            .modifier(TextMod(.title, .semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } //: VStack
                } //: HStack
                .padding(.horizontal)
                
                Button {
                    //
                } label: {
                    Text("Modify")
                        .frame(maxWidth: .infinity)
                        .modifier(TextMod(.title3, .semibold, .white))
                    
                    Image(systemName: "pencil")
                }
                .modifier(RoundedButtonMod())
                
                
                Spacer()
            } //: VStack
            .padding()
            .frame(maxWidth: 500)
            .background(lightFgColor)
        } //: If - Else
    } //: Body
}

struct ItemDetailView_Previews: PreviewProvider {
    @State static var selectedItem: InventoryItemEntity?
    static var previews: some View {
        ItemDetailView(selectedItem: $selectedItem)
            .modifier(PreviewMod())
            .previewLayout(.sizeThatFits)
    }
}
