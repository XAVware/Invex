//
//  CategorySlider.swift
//  ConcessionTrackerComponents
//
//  Created by Smetana, Ryan on 6/16/21.
//

import SwiftUI

struct CategorySlider: View {
    
//    @Binding var selectedCategoryName: String
    
    @Binding var categoryIndex: Int
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false, content: {
            HStack(spacing: 2) {
                ForEach(categoryList, id: \.self) { category in
                    Button(action: {
                        self.categoryIndex = categoryList.firstIndex(of: category)!
//                        self.selectedCategoryName = category.name
                    }, label: {
                        Text(category.name)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 7)
                            .foregroundColor(.black)
//                            .opacity(self.selectedCategoryName == category.name ? 1.0 : 0.65)
                            .opacity(categoryList[categoryIndex].name == category.name ? 1.0 : 0.65)
                    })
                    .frame(minWidth: 150)
                    .background(categoryList[categoryIndex].name == category.name ? Color.white : Color(UIColor.systemGray4))
                    .cornerRadius(15, corners: .bottomLeft)
                    .cornerRadius(15, corners: .bottomRight)
                    
                    Divider().background(Color.black).padding(.vertical, 4)
                }
                
            }
        })
        .background(Color(UIColor.systemGray4).frame(maxWidth: .infinity))
        .frame(maxWidth: .infinity, maxHeight: 40)
    }
}

