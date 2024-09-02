//
//  NeomophicCardView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 8/29/24.
//

import SwiftUI

struct NeomorphicCardView: View {
    @Environment(\.colorScheme) var colorScheme
    enum Layer { case under, over }
    
    @State var layer: Layer
    
    var body: some View { 
        switch layer {
        case .under:
            RoundedRectangle(cornerRadius: 18)
                .fill(
                    .shadow(.inner(color: .neoUnderDark, radius: 3, x: 1, y: 1))
                    .shadow(.inner(color: .neoUnderLight, radius: 2, x: -3, y: -2))
                )
                .foregroundColor(.neoUnderBg)
            
        case .over:
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    .shadow(.inner(color: .neoOverLight, radius: 3, x: 2, y: 2 ))
                    .shadow(.inner(color: .neoOverDark, radius: 2, x: -2, y: -2))
                )
                .foregroundColor(.bg)
                .blendMode(colorScheme == .dark ? .plusLighter : .plusDarker)
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
