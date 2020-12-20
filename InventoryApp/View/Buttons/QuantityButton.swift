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
            Text("\(value)")
                .font(.system(size: 18, weight: selectedQuantity == value ? .semibold : .light, design: .rounded))
                .foregroundColor(.black)
        }
        .frame(width: 30)
    }
}

