//
//  NeomophicCardView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 8/29/24.
//

import SwiftUI

struct NeomorphicCardView: View {
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
            //        RoundedRectangle(cornerRadius: 12)
            //            .fill(
            //                LinearGradient(gradient: Gradient(stops: [
            //                    Gradient.Stop(color: .neoOverLight, location: 0),
            //                    Gradient.Stop(color: .neoOverDark, location: 1)
            //                ]), startPoint: .topLeading, endPoint: .bottomTrailing)
            //            )
            //            .shadow(color: .white, radius: 1.5, x: -2, y: -2)
            //            .shadow(color: .neoOverDark, radius: 2, x: 2, y: 2)
            //            .blendMode(.luminosity)
                    RoundedRectangle(cornerRadius: 24)
                        .fill(
                            .shadow(.inner(color: .fcfcfc, radius: 2, x: 3, y: 3))
                            .shadow(.inner(color: .neoUnderDark.opacity(0.8), radius: 2, x: -2, y: -2))
                        )
                        .foregroundColor(.bg)
            //            .blendMode(.plusDarker)
            //            .shadow(color: .neoUnderDark.opacity(0.3), radius: 6, x: -2, y: -2)
            //            .shadow(color: .bg, radius: 6, x: 2, y: 2)
            //            .blendMode(.luminosity)
        }
    }
}

#Preview {
    ZStack {
//        LinearGradient(gradient: Gradient(stops: [
//            Gradient.Stop(color: .bg.opacity(0.6), location: 0),
////            Gradient.Stop(color: .bg.opacity(0.5), location: 0.25),
//            Gradient.Stop(color: .bg, location: 1)
//        ]), startPoint: .topLeading, endPoint: .bottomTrailing)
//        
        Color.bg
        NeomorphicCardView(layer: .under)
            .padding(64)
    }
}
