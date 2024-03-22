//
//  RoundedButtonMod.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/24/23.
//

import SwiftUI

struct PrimaryButtonMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .frame(maxWidth: 420, maxHeight: 54)
            .background(.ultraThinMaterial)
            .background(Theme.primaryColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct ThemeFieldMod: ViewModifier {
    @State var overlayText: String = ""
    
    func body(content: Content) -> some View {
        content
            .padding(.leading, overlayText.isEmpty ? 0 : 48)
            .padding(8)
            .frame(maxWidth: .infinity, maxHeight: 42)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(lineWidth: 0.5)
                    .foregroundStyle(.gray)
            )
            .overlay(overlayText.isEmpty ? nil : highlight, alignment: .leading)
    }
    
    private var highlight: some View {
        ZStack {
            RoundedCorner(radius: 6, corners: [.topLeft, .bottomLeft])
                .fill(Color("Purple800"))
                .frame(width: 42)
            Text(overlayText)
                .foregroundStyle(Color("Purple050"))
                .font(.headline)
                .fontDesign(.rounded)
        }
    }
}


struct FieldTitleMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .fontWeight(.semibold)
            .fontDesign(.rounded)
            .foregroundStyle(.black)
    }
}

struct FieldSubtitleMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .fontWeight(.medium)
            .fontDesign(.rounded)
            .foregroundStyle(.gray)
    }
}
