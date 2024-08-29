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
        HStack(spacing: 16) {
            Image(systemName: highlight.iconName)
                .foregroundStyle(.accent)
                .padding(6)
                .font(vSize == .regular ? .largeTitle : .title2)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(highlight.title)
                    .font(.headline)
                
                Text(highlight.caption)
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                    .frame(minHeight: 42)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        } //: HStack
    }
}

#Preview {
    LandingHighlightView(highlight: LandingHighlight(iconName: "archivebox", title: "Title", caption: "Caption"), vSize: .regular)
}
