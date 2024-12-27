//
//  LandingHightextLightView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 8/30/24.
//

import SwiftUI

struct LandingHightextLightView: View {
    @Environment(\.horizontalSizeClass) var hSize
    @Environment(\.verticalSizeClass) var vSize
    private var isIphone: Bool { hSize == .compact || vSize == .compact }
    @State var highlight: LandingHighlight
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Spacer()
            Text(highlight.title)
                .font(isIphone ? .title3 : .title)
                .fontWeight(.semibold)
                .foregroundStyle(.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(highlight.caption)
                .font(isIphone ? .headline : .title3)
                .fontWeight(.regular)
                .multilineTextAlignment(.leading)
                .lineSpacing(4)
                .padding(.trailing)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
        } //: VStack
        .fontDesign(.rounded)
    }
}

#Preview {
    LandingHightextLightView(highlight: LandingHighlight(imageName: "LandingImage", title: "title", caption: "caption"))
}
