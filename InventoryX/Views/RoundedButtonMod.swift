//
//  RoundedButtonMod.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/24/23.
//

import SwiftUI

struct RoundedButtonMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.title2)
            .fontWeight(.semibold)
            .padding()
            .frame(maxWidth: 350, maxHeight: 50)
            .background(Theme.primaryColor)
            .cornerRadius(25)
            .shadow(radius: 3)
    }
}
