//
//  ThemeField-Mod.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/25/24.
//

import SwiftUI

struct ThemeFieldMod: ViewModifier {
    @State var overlayText: String = ""
    @State var overlaySide: Alignment = .leading
    
    func body(content: Content) -> some View {
        content
            .padding(.leading, overlayText.isEmpty ? 0 : 42)
            .padding()
            .frame(maxHeight: 48)
            .background(.white.opacity(0.95))
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .overlay(overlayText.isEmpty ? nil : highlight, alignment: overlaySide)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(lineWidth: 0.5)
                    .foregroundStyle(.gray)
                    .shadow(color: Color("Purple050"), radius: 4, x: 3, y: 3)
                    .shadow(color: Color("Purple050"), radius: 4, x: -3, y: -3)
            )
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .shadow(color: Color.gray.opacity(0.25), radius: 4, x: 0, y: 0)
    }
    
    private var highlight: some View {
        ZStack {
            RoundedCorner(radius: 6, corners: overlaySide == .leading ? [.topLeft, .bottomLeft] : [.topRight, .bottomRight])
                .fill(.accent.opacity(0.9))
                .opacity(0.8)
                .frame(width: 42)
            Text(overlayText)
                .foregroundStyle(Color("Purple050"))
                .font(.subheadline)
                .fontDesign(.rounded)
        }
    }
}
