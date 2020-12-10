//
//  CartItemView.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/10/20.
//

import SwiftUI

struct CartItemView: View {
    @State var quantity: Int = 1
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text("Pepsi")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: 120, alignment: .leading)
                
                HStack(spacing: 0) {
                    Button(action: {
                        self.quantity += 1
                    }) {
                        Image(systemName: "minus.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .accentColor(Color.white)
                    }
                    
                    Text("\(quantity)")
                        .padding()
                        .foregroundColor(.white)
                        .frame(width: 50, height: 40, alignment: .center)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                    
                    
                    Button(action: {
                        self.quantity -= 1
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .accentColor(Color.white)
                    }
                } //: HStack - Stepper
                
                Text("$ 1.00")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: 120, alignment: .trailing)
            }
            Divider().background(Color.white).padding(.horizontal)
        }
        .frame(width: 360, height: 40)
        .background(Color.clear)
    }
}

struct CartItemView_Previews: PreviewProvider {
    static var previews: some View {
        CartItemView()
            .previewLayout(.sizeThatFits)
    }
}
