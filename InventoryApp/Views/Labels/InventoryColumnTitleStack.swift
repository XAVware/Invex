//
//  InventoryListDetailLabel.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/22/20.
//

import SwiftUI

struct InventoryColumnTitleStack: View {
    @State var listWidth: CGFloat
    
    var columnTitles: [String] = ["Item Name:", "Type:", "On-Hand Qty:", "Price:", "Cost / Unit:"]
    
    var body: some View {
        HStack(spacing: 0) {
            
            ForEach(columnTitles, id: \.self) { title in
                Text(title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                    .opacity(0.7)
                    .frame(width: (listWidth / CGFloat(columnTitles.count)), alignment: self.getAlignmentFor(title: title))
            }
            
        } //: HStack
        .frame(height: 40)
    }
    
    func getAlignmentFor(title: String) -> Alignment {
        print(title)
        if title == columnTitles[0] {
            return .leading
        } else if title == columnTitles[columnTitles.count - 1] {
            return .trailing
        } else {
            return .center
        }
    }
}
