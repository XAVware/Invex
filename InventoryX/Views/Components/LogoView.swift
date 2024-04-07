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
                .font(.title)
                .fontWeight(.semibold)
                .offset(y: -2)
            
            Text("X")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .italic()
                .offset(x: -2)
        } //: HStack
        .foregroundStyle(.accent)
    } //: Body
}
