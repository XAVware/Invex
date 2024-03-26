//
//  LogoView.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 5/3/23.
//

import SwiftUI

struct LogoView: View {
    
    var body: some View {
        HStack(spacing: 0) {
            Text("Inve")
                .modifier(TextMod(.title, .semibold, Theme.logoColor))
                .offset(y: -2)
            
            Text("X")
                .modifier(TextMod(.largeTitle, .semibold, Theme.logoColor))
                .italic()
                .offset(x: -2)
        } //: HStack
        .foregroundColor(Theme.logoColor)
    } //: Body
}
