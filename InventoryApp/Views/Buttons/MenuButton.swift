//
//  MenuButton.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/20/20.
//

import SwiftUI

struct MenuButton: View {
    @State var title: String
    @State var action: () -> Void
    
    var body: some View {
        VStack {
            Button(action: { action() }) {
                Text(title)
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .frame(height: 60)
                    .foregroundColor(.white)
            }
            
            Divider().background(Color.white)
        }
    }
}

struct MenuButton_Previews: PreviewProvider {
    static var previews: some View {
        MenuButton(title: "Make A Sale") {
            
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
}
