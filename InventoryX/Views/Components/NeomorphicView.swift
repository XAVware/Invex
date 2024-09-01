//
//  NeomorphicView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 9/1/24.
//

import SwiftUI

struct NeomorphicView<C: View>: View {
    @Environment(\.verticalSizeClass) var vSize

    let content: C
    
    init(@ViewBuilder content: (() -> C)) {
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .center) {
                (vSize == .regular ? Color.bg : Color.neoUnderBg).ignoresSafeArea()
                
                /// If the screen is large enough, place a NeomorphicCard behind the content to give the illusion of depth
                if vSize == .regular {
                    NeomorphicCardView(layer: .under)
                }
                
                content
            }
            .padding(.leading, max(8, geo.safeAreaInsets.leading)) // Padding on side of NeoCard. Use the width of safe areas unless they're less than 8
            .padding(.trailing, max(8, geo.safeAreaInsets.trailing))
        }
    }
    
}

