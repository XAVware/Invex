//
//  QuantityStepper.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/20/20.
//

import SwiftUI

struct QuantityStepper: View {
    @Binding var selectedQuantity: Int
    
    var body: some View {
        HStack(spacing: 10) {
            Button(action: {
                self.selectedQuantity -= 1
            }) {
                Image(systemName: "minus.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .accentColor(Color.blue.opacity(0.8))
            }
            
            ZStack {
                Color(UIColor.tertiarySystemFill)
                    .cornerRadius(9)
                    .frame(height: 30, alignment: .center)
                
                Text("\(selectedQuantity)")
                    .foregroundColor(.black)
                    .frame(width: 80, height: 40, alignment: .center)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
            } //: ZStack
            
            Button(action: {
                self.selectedQuantity += 1
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .accentColor(Color.blue.opacity(0.8))
            }
        }//: HStack
    }
}
