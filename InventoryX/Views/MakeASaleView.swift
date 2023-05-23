//
//  MakeASaleView.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 5/1/23.
//

import SwiftUI
import RealmSwift

struct MakeASaleView: View {
    @ObservedRealmObject var selectedCategory: CategoryEntity
    @ObservedObject var cart: Cart = Cart()
    @State var counter: Int = 0
    
    
    func getColumns(gridWidth: CGFloat) -> [GridItem] {
        let itemSize = gridWidth * 0.20
        let numberOfColums = 4
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
        mainView
    } //: Body
    
    @ViewBuilder private var mainView: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                VStack(spacing: 0) {
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
                    
                    Divider()
                    
                    buttonPanel
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(XSS.S.color80))
                .cornerRadius(20, corners: [.topLeft, .topRight, .bottomRight])
                
                VStack {
                    Text("Cart")
                        .modifier(TextMod(.title3, .semibold, lightTextColor))
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    Button {
                        //
                    } label: {
                        Text("Check Out")
                            .modifier(TextMod(.title3, .semibold, lightTextColor))
                            .frame(maxWidth: .infinity)
                    }
                    
                } //: VStack
                .edgesIgnoringSafeArea(.trailing)
                .frame(maxWidth: geo.size.width / 4)
                .background(.clear)
            } //: HStack
            
        }
    } //: Main View
    
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
}

struct MakeASaleView_Previews: PreviewProvider {
    @State static var category: CategoryEntity = CategoryEntity.foodCategory
    static var previews: some View {
        MakeASaleView(selectedCategory: category)
            .modifier(PreviewMod())
    }
}
