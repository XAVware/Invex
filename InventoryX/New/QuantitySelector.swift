//
//  QuantitySelector.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/24/23.
//

import SwiftUI

struct QuantitySelector: View {
    @Binding var selectedQuantity: Int
    @State var showsCustomToggle: Bool = true
    @State var isCustom: Bool = false {
        willSet(newValue) {
            withAnimation { isCustom = newValue }
        }
    }
    private let quantityOptions: [Int] = [5, 10, 15, 30]
    
    enum Style { case preset, custom, full }
    @State var selectedStyle: Style = .full
    
    func adjustQuantity(by val: Int) {
        var tempQty: Int = selectedQuantity + val
        guard tempQty >= 0 else {
            tempQty = 0
            return
        }
        selectedQuantity = tempQty
    }
    
    func quantitySelected(value: Int) {
        withAnimation { isCustom = false }
        selectedQuantity = value
    }
    
    func customTapped() {
        withAnimation { isCustom = true }
    }
    
    var body: some View {
        VStack {
            headerView

            presetQuantities
            
            if isCustom {
                customPicker
            }
        } //: VStack
        .frame(maxWidth: 400)
    } //: Body
    
    private var customPicker: some View {
        HStack(spacing: 8) {
            Button {
                adjustQuantity(by: -1)
            } label: {
                Image(systemName: "minus.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
            }
            .frame(width: 45, height: 45)
            .shadow(radius: 2)
            .tint(primaryColor)
            
            Text("\(selectedQuantity)")
                .modifier(TextMod(.title2, .bold, .black))
            
            Button {
                adjustQuantity(by: 1)
            } label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
            }
            .frame(width: 45, height: 45)
            .shadow(radius: 2)
            .tint(primaryColor)
        }//: HStack
    } //: Custom Picker
    
    private var headerView: some View {
        HStack {
            Spacer()
            Toggle("Custom", isOn: $isCustom)
                .scaleEffect(0.9)
                .modifier(TextMod(.footnote, .light, .gray))
                .frame(maxWidth: 105)
        } //: HStack
    } //: Header View
    
    private var presetQuantities: some View {
        HStack(spacing: 16) {
            Text("Quantity on hand:")
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()
            
            ForEach(quantityOptions, id: \.self) { val in
                Button {
                    quantitySelected(value: val)
                } label: {
                    Text("\(val)")
                        .underline(selectedQuantity == val ? true : false)
                        .opacity(selectedQuantity == val ? 1.0 : 0.5)
                        .modifier(TextMod(.title2, .bold, .black))
                }
            } //: For Each
        } //: HStack
        .foregroundColor(.black)
    } //: Preset Quantities
}


struct QuantitySelector_Previews: PreviewProvider {
    @State static var qty: Int = 12
    static var previews: some View {
        QuantitySelector(selectedQuantity: $qty)
            .previewLayout(.sizeThatFits)
    }
}
