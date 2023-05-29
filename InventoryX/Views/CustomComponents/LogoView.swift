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
            Text("Inventory")
                .modifier(TextMod(.title, .semibold, Color(XSS.S.color30)))
                .offset(y: -2)
            
            Text("X")
                .modifier(TextMod(.largeTitle, .semibold, Color(XSS.S.color30)))
                .italic()
                .offset(x: -2)
        } //: HStack
        .foregroundColor(Color(XSS.S.color30))
    } //: Body
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
            .modifier(PreviewMod())
    }
}
