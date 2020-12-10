//
//  BeverageButton.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/9/20.
//

import SwiftUI

struct ItemButton: View {
    var item: Item
    
    @State var colorHexString: String
    
    var body: some View {
        Button(action: {
            
        }) {
            VStack(spacing: 0) {
                Text(item.name)
                    .font(.system(size: 18, weight: .bold, design:.rounded))
                    .foregroundColor(.black)
                    
                Text("$ \(item.retailPrice)")
                    .font(.system(size: 14, weight: .semibold, design:.rounded))
                    .foregroundColor(.black)
                    
            }
            
        }
        .frame(minWidth: 50, maxWidth: 200, minHeight: 40, maxHeight: 40)
        .background(
            Color(hex: self.colorHexString)
                .cornerRadius(15)
                .shadow(radius: 4)
        )
        .padding()

        
    }
    
}

//struct BeverageButton_Previews: PreviewProvider {
//    static var previews: some View {
//        BeverageButton()
//            .previewLayout(.sizeThatFits)
//    }
//}
