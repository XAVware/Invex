//
//  CategorySlider.swift
//  ConcessionTrackerComponents
//
//  Created by Smetana, Ryan on 6/16/21.
//

import SwiftUI

struct CategorySlider: View {
    
    @Binding var selectedCategoryName: String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false, content: {
            HStack(spacing: 2) {
                ForEach(categoryList, id: \.self) { category in
                    Button(action: {
                        self.selectedCategoryName = category.name
                    }, label: {
                        Text(category.name)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 7)
                            .foregroundColor(.black)
                            .opacity(self.selectedCategoryName == category.name ? 1.0 : 0.65)
                    })
                    .frame(minWidth: 150)
                    .background(self.selectedCategoryName == category.name ? Color.green : Color.white)
                    .cornerRadius(15, corners: .bottomLeft)
                    .cornerRadius(15, corners: .bottomRight)
                    
                    Divider().background(Color.black).padding(.vertical, 4)
                }
                
            }
        })
    }
}

