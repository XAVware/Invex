//
//  QuantitySelector.swift
//  ConcessionTracker
//
//  Created by Ryan Smetana on 1/21/21.
//

import SwiftUI

struct QuantitySelector: View {
    @Binding var selectedQuantity: Int
    @State var showsCustomToggle: Bool
    @State var quantityOptions: [Int]       = [12, 18, 24, 30, 36]
    @State var isCustomQuantity: Bool       = false
    
    var body: some View {
        VStack {
            if self.showsCustomToggle {
                Toggle(isOn: self.$isCustomQuantity) {
                    Text("Custom Qty")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(.black)
                }
                .frame(maxWidth: 150)
                .padding(.bottom)
            }
            
            if self.isCustomQuantity || !self.showsCustomToggle {
                
                HStack(spacing: 20) {
                    Button(action: {
                        self.selectedQuantity -= 1
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .resizable()
                    }
                    .modifier(PlusMinusButtonModifier())
                    
                    Text("\(selectedQuantity)")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .frame(maxWidth: 100)
                        .foregroundColor(Color.black)
                    
                    Button(action: {
                        self.selectedQuantity += 1
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                    }
                    .modifier(PlusMinusButtonModifier())
                }//: HStack
                .frame(width: 400)
                
            } else {
                HStack {
                    ForEach(self.quantityOptions, id: \.self) { value in
                        Button(action: {
                            self.selectedQuantity = value
                        }) {
                            Text("\(value)")
                                .underline(self.selectedQuantity == value ? true : false)
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .opacity(self.selectedQuantity == value ? 1.0 : 0.5)
                        }
                    }
                    .frame(width: 60)
                } //: HStack
                .foregroundColor(.black)
            }
            
        }
    }
}
