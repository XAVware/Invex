//
//  NeomophicCardView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 8/29/24.
//

import SwiftUI



struct NeomorphicCardView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var layer: NeomorphicLayer
    @State var cornerRadius: CGFloat
    
    enum NeomorphicLayer {
        case under, over
        var defaultCornerRadius: CGFloat {
            switch self {
            case .under: 18
            case .over: 12
            }
        }
    }
    
    init(layer: NeomorphicLayer, cornerRadius: CGFloat? = nil) {
        self.layer = layer
        if let r = cornerRadius {
            self.cornerRadius = r
        } else {
            self.cornerRadius = layer.defaultCornerRadius
        }
    }
    var body: some View {
        switch layer {
        case .under:
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(
                    .shadow(.inner(color: .neoUnderDark, radius: 3, x: 1, y: 1))
                    .shadow(.inner(color: .neoUnderLight, radius: 2, x: -3, y: -2))
                )
                .foregroundColor(.neoUnderBg)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(.e0E0E0, lineWidth: 0.5)
                        .blur(radius: 0.5)
                )
        case .over:
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(
                    .shadow(.inner(color: .neoOverLight, radius: 3, x: 2, y: 2 ))
                    .shadow(.inner(color: .neoOverDark, radius: 2, x: -2, y: -2))
                )
                .foregroundColor(.neoOverBg)
//                .blendMode(colorScheme == .dark ? .plusLighter : .plusDarker)
        }
    }
}

#Preview {
    ZStack {
        Color.bg
        NeomorphicCardView(layer: .under)
            .padding(64)
    }
}
