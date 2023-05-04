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
    
    var body: some View {
        mainView
    } //: Body
    
    @ViewBuilder private var mainView: some View {
        GeometryReader { geo in
            if selectedCategory.items.count > 0 {
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
                
            } else {
                noItemsView
            } //: If-Else
        }
    } //: Main View
    
    private var noItemsView: some View {
        VStack {
            Text("No Items in this category yet.")
            addItemButton
                .modifier(RoundedButtonMod())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    } //: No Items View
    
    private var buttonPanel: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                LazyVGrid(columns: getColumns(gridWidth: geo.size.width), spacing: 0) {
                    ForEach(selectedCategory.items) { item in
                        Button {
//                                cart.addItem(item)
                        } label: {
                            Text(item.name)
                                .modifier(TextMod(.title3, .semibold, .black))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .frame(height: 80)
//                        .frame(width: geo.size.width * 0.18, height: 80)
                        .background(Color(XSS.ComplimentS.color70))
                        .cornerRadius(9)
//                        .padding()
                        .shadow(radius: 8)
                    } //: ForEach
                } //: LazyVGrid
                .padding()
                Spacer()
            } //: VStack
        } //: Geometry Reader
    } //: Button Panel
    
    private var addItemButton: some View {
        Button {
            let item = InventoryItemEntity()
            item.name = "Item \(counter)"
            item.retailPrice = 1.00
            
            do {
                let realm = try Realm()
                try realm.write {
                    $selectedCategory.items.append(item)
                    print("Item Added: \n \(item)")
                    
                }
            } catch {
                print(error.localizedDescription)
            }
            counter += 1
        } label: {
            Text("Add Item")
        }
        .modifier(RoundedButtonMod())
    } //: Add Item View
}

struct MakeASaleView_Previews: PreviewProvider {
    @State static var category: CategoryEntity = CategoryEntity.foodCategory
    static var previews: some View {
        MakeASaleView(selectedCategory: category)
            .modifier(PreviewMod())
    }
}
