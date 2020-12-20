//
//  QuantityPicker.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/20/20.
//

import SwiftUI

struct QuantityPicker: View {
    @Binding var selectedQuantity: Int
    @State var isCustomQuantity: Bool       = false
    @State var customValue: String          = "10"
    
    var body: some View {
        HStack {
            Spacer(minLength: 0)
            
            QuantityButton(selectedQuantity: self.$selectedQuantity, value: 12) {
                if self.isCustomQuantity { withAnimation { self.isCustomQuantity.toggle() } }
            }
            
            QuantityButton(selectedQuantity: self.$selectedQuantity, value: 18) {
                if self.isCustomQuantity { withAnimation { self.isCustomQuantity.toggle() } }
            }
            
            QuantityButton(selectedQuantity: self.$selectedQuantity, value: 24) {
                if self.isCustomQuantity { withAnimation { self.isCustomQuantity.toggle() } }
            }
            
            QuantityButton(selectedQuantity: self.$selectedQuantity, value: 30) {
                if self.isCustomQuantity { withAnimation { self.isCustomQuantity.toggle() } }
            }
            
            QuantityButton(selectedQuantity: self.$selectedQuantity, value: 36) {
                if self.isCustomQuantity { withAnimation { self.isCustomQuantity.toggle() } }
            }
            
            Button(action: {
                withAnimation { self.isCustomQuantity.toggle() }
                self.customValue = "\(self.selectedQuantity)"
            }) {
                Text("Custom")
                    .font(.system(size: 18, weight: self.isCustomQuantity ? .semibold : .light, design: .rounded))
                    .foregroundColor(.black)
            }
            .frame(width: 70)
            
            if self.isCustomQuantity {
                QuantityStepper(selectedQuantity: self.$selectedQuantity)
            }
            
        }//: HStack
        .frame(width: 410, height: 30)
        
        
    }
    
}
