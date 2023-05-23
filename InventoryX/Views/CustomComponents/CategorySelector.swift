//
//  CategorySelector.swift
//  InventoryX
//
//  Created by Ryan Smetana on 5/22/23.
//

import SwiftUI
import RealmSwift

struct CategorySelector: View {
    @ObservedResults(CategoryEntity.self) var categories
    @Binding var selectedCategory: CategoryEntity?
    
    enum Style { case scrollingTab, scrollingButton }
    let style: Style = .scrollingButton
    
    private func setDefaultCategory() {
        guard let defaultCategory = categories.first else { return }
        selectedCategory = defaultCategory
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 2) {
                switch style {
                case .scrollingTab:
                    ForEach(categories) { category in
                        Button {
                            selectedCategory = category
                        } label: {
                            Text(category.name)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            
                                .opacity(selectedCategory == category ? 1.0 : 0.65)
                        }
                        .frame(minWidth: 150)
                        .background(selectedCategory == category ? Color.white : Color(UIColor.systemGray4))
                        .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
                        
                        Divider()
                            .background(Color.black)
                            .padding(.vertical, 4)
                    }
                    
                case .scrollingButton:
                    ForEach(categories) { category in
                        Button {
                            selectedCategory = category
                        } label: {
                            Text(category.name)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .foregroundColor(selectedCategory == category ? Color(XSS.S.color10) : Color(XSS.S.color90))
                            
                        }
                        .frame(minWidth: 150)
                        .background(selectedCategory == category ? Color(XSS.S.color80) : Color(XSS.S.color40))
                        .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
                        
                    }
                } //: Switch
            } //: HStack
        } //: Scroll
        .frame(maxWidth: .infinity, maxHeight: 40)
        .background(.clear)
        .onAppear {
            setDefaultCategory()
        }
    } //: Body
}

struct CategorySelector_Previews: PreviewProvider {
    @State static var category: CategoryEntity? = CategoryEntity.foodCategory
    static var previews: some View {
        CategorySelector(selectedCategory: $category)
    }
}
