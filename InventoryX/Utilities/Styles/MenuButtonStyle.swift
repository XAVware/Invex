//
//  ThemeButtonStyle.swift
//  InventoryX
//
//  Created by Ryan Smetana on 8/30/24.
//

import SwiftUI
struct MenuButtonStyle: ButtonStyle {
    @Environment(\.verticalSizeClass) var vSize
    @Environment(\.horizontalSizeClass) var hSize
    let trailingIcon: String
    
    init(trailingIcon: String = "chevron.right") {
        self.trailingIcon = trailingIcon
    }
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: 42)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.subheadline)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
            .overlay(
                Image(systemName: trailingIcon)
                    .padding(.trailing)
                , alignment: .trailing
            )
    }
}
