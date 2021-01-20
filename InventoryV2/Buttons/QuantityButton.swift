//
//  QuantityButton.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/20/20.
//

import SwiftUI

struct QuantityButton: View {
    @Binding var selectedQuantity: Int
    @State var value: Int
    @State var action: () -> Void
    
    var body: some View {
        Button(action: {
            self.selectedQuantity = self.value
        }) {
            Text("\(value)").underline(self.selectedQuantity == self.value ? true : false)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: "365cc4"))
                .opacity(self.selectedQuantity == self.value ? 1.0 : 0.7)
        }
        .frame(width: 60)
    }
}

