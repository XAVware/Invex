//
//  QuantityStepper.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/20/20.
//

import SwiftUI

struct QuantityStepper: View {
    @Binding var selectedQuantity: Int
    
    var width: CGFloat = 400
    
    var body: some View {
        HStack(spacing: 20) {
            Button(action: {
                self.selectedQuantity -= 1
            }) {
                Image(systemName: "minus.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: width / 10)
                    .accentColor(Color(hex: "365cc4"))
            }
            .shadow(radius: 2)
            
            Text("\(selectedQuantity)")
                .padding(.horizontal)
                .padding(.vertical, 5)
                .multilineTextAlignment(.center)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .frame(maxWidth: 100)
                
            Button(action: {
                self.selectedQuantity += 1
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: width / 10)
                    .accentColor(Color(hex: "365cc4"))
            }
            .shadow(radius: 2)
        }//: HStack
        .frame(width: self.width)
    }
}
