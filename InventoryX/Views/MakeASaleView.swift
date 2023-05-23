//
//  MakeASaleView.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 5/1/23.
//

import SwiftUI
import RealmSwift

struct MakeASaleView: View {
    @ObservedResults(CategoryEntity.self) var categories
    @State var selectedCategory: CategoryEntity = .init()
    @ObservedObject var cart: CartViewModel = CartViewModel()
    @State var counter: Int = 0
    
    private func setDefaultCategory() {
        guard let defaultCategory = categories.first else { return }
        selectedCategory = defaultCategory
    }
    
    func getColumns(gridWidth: CGFloat) -> [GridItem] {
        let itemSize = gridWidth * 0.20
        //        let numberOfColums = 4
        let itemSpacing = gridWidth * 0.05
        
        let columns = [
            GridItem(.fixed(itemSize), spacing: itemSpacing),
            GridItem(.fixed(itemSize), spacing: itemSpacing),
            GridItem(.fixed(itemSize), spacing: itemSpacing),
            GridItem(.fixed(itemSize), spacing: itemSpacing)
        ]
        return columns
    }
    
    func itemTapped(item: InventoryItemEntity) {
        cart.addItem(item)
    }
    
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        searchBar
                        
                        Divider()
                        
                        buttonPanel
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color(XSS.S.color80))
                    .cornerRadius(20, corners: [.topLeft, .topRight, .bottomRight])
                    
                    categorySelector
                } //: VStack
                
                
                CartView()
                    .frame(width: geo.size.width * 0.25)
            } //: HStack
            
        } //: Geometry Reeader
        .onAppear {
            setDefaultCategory()
        }
    } //: Body
    
    private var searchBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: 16)
                .bold()
            
            Text("Search...")
                .modifier(TextMod(.title3, .semibold, .gray))
            
            Spacer()
        } //: HStack
        .padding(.horizontal)
        .frame(height: 40)
        .foregroundColor(.gray)
    } //: Search Bar
    
    private var buttonPanel: some View {
        GeometryReader { geo in
            if selectedCategory.items.count > 0 {
                VStack(spacing: geo.size.width * 0.05) {
                    LazyVGrid(columns: getColumns(gridWidth: geo.size.width), spacing: 0) {
                        ForEach(selectedCategory.items) { item in
                            Button {
                                itemTapped(item: item)
                            } label: {
                                Text(item.name)
                                    .modifier(TextMod(.title3, .semibold, .black))
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                            .frame(height: 80)
                            .background(Color(XSS.ComplimentS.color70))
                            .cornerRadius(9)
                            .shadow(radius: 8)
                        } //: ForEach
                    } //: LazyVGrid
                    .padding()
                    Spacer()
                } //: VStack
            } else {
                VStack {
                    Spacer()
                    Text("No Items Yet!")
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            } //: If - Else
        } //: Geometry Reader
    } //: Button Panel
    
    private var categorySelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 2) {
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
            } //: HStack
        } //: Scroll
        .frame(maxWidth: .infinity, maxHeight: 40)
        .background(.clear)
        .onAppear {
            setDefaultCategory()
        }
    } //: Category Selector
}

struct MakeASaleView_Previews: PreviewProvider {
    @State static var category: CategoryEntity = CategoryEntity.foodCategory
    static var previews: some View {
        MakeASaleView(selectedCategory: category)
            .modifier(PreviewMod())
    }
}
