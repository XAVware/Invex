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
    @State var isCustom: Bool = true {
        willSet(newValue) {
            //This caused the app to crash after clicking on the toggle while the CategoryName field was focused
            withAnimation { isCustom = newValue }
        }
    }
    let headerText: String = "Qty on hand:"
    
    private let presetQuantityOptions: [Int] = [5, 10, 15, 30]
    private let customQuantityIncrements: [Int] = [1, 5, 10, 50]
    
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
    
    var body: some View {
        VStack {
            topRow
            Divider()
            presetQuantities
                .padding(.bottom, 8)
        } //: VStack
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(XSS.S.color10), lineWidth: 0.5))
    } //: Body
    
    private var topRow: some View {
        HStack {
            Text(headerText)
                .frame(maxWidth: .infinity, alignment: .leading)
                .modifier(TextMod(.footnote, .regular))
            
            if isCustom {
                Text("\(selectedQuantity)")
                    .modifier(TextMod(.title2, .semibold))
                    .frame(maxWidth: .infinity, alignment: .center)
                
            } else {
                Spacer()
            }
            
            Toggle("Custom", isOn: $isCustom)
                .scaleEffect(0.9)
                .modifier(TextMod(.footnote, .regular))
                .frame(width: 105)
        } //: HStack
        .padding(.top, 8)
        .padding(.horizontal, 8)
    } //: Header View
    
    private var customQuantities: some View {
        HStack(spacing: 16) {
            ForEach(customQuantityIncrements, id: \.self) { val in
                Button {
                    quantitySelected(value: val)
                } label: {
                    Text("\(val > 0 ? "+" : "")\(val)")
                        .modifier(TextMod(.body, .semibold, .white))
                        .frame(width: 40)
                }
                .padding(8)
                .background(Color(XSS.S.color30))
                .clipShape(Capsule())
                .shadow(radius: 4)
                
            }
        } //: HStack
    } //: Preset Quantities
    
    private var presetQuantities: some View {
        HStack(spacing: 16) {
            ForEach(presetQuantityOptions, id: \.self) { val in
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
    } //: Preset Quantities
    
    private var customPickerIncremental: some View {
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
            .tint(lightFgColor)
            
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
            .tint(lightFgColor)
        }//: HStack
    } //: Custom Picker
}


struct QuantitySelector_Previews: PreviewProvider {
    @State static var qty: Int = 12
    static var previews: some View {
        QuantitySelector(selectedQuantity: $qty)
            .previewLayout(.sizeThatFits)
    }
}
