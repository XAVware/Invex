//
//  HexImage.swift
//  InventoryX
//
//  Created by Ryan Smetana on 8/30/24.
//

import SwiftUI

struct HexImage: View {
    @Environment(\.horizontalSizeClass) var hSize
    @Environment(\.verticalSizeClass) var vSize
    @Environment(\.colorScheme) var colorScheme
    private var isIphone: Bool { hSize == .compact || vSize == .compact }
    @State var imageName: String
    
    var body: some View {
        ZStack {
            Hexagon()
                .fill(Color.bg)
                .rotationEffect(Angle(degrees: isIphone ? 0 : 30))
                .shadow(color: Color.shadow200.opacity(0.8), radius: 3, x: 2, y: 2)
                .shadow(color: Color.bg000, radius: 2, x: -3, y: -3)
            
            Image(imageName)
                .resizable()
                .scaledToFit()
                .padding(32)
                .frame(maxWidth: 460)
                .opacity(0.8)
        } //: ZStack
    }
}
