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
            .foregroundColor(secondaryColor)
            .modifier(TextMod(.title2, .semibold))
            .padding()
            .frame(height: 50)
            .background(primaryColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
