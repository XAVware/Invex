//
//  LandingHighlight.swift
//  InventoryX
//
//  Created by Ryan Smetana on 8/15/24.
//

import SwiftUI

struct LandingHighlightView: View {
    let highlight: LandingHighlight
    let vSize: UserInterfaceSizeClass?
    
    var body: some View {
        ZStack(alignment: .center) {
            NeomophicCardView(layer: .under)
            
            VStack(spacing: 16) {
                Image(highlight.imageName)
                    .resizable()
                    .scaledToFit()
//                    .rotationEffect(Angle(degrees: -4))
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(highlight.title)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(.accent)
                    
                    Text(highlight.caption)
                        .font(.title3)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                        .frame(minHeight: 42)
                } //: VStack
                .fontDesign(.rounded)
                .padding()
                .frame(maxWidth: 540, maxHeight: 180, alignment: .leading)
            } //: VStack
            .padding()
            .frame(maxWidth: 540)
        }
    }
}

#Preview {
    LandingHighlightView(highlight: LandingHighlight(imageName: "archivebox", title: "Title", caption: "Caption"), vSize: .regular)
}
