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
    
    var body: some View {
        mainView
    } //: Body
    
    @ViewBuilder private var mainView: some View {
        GeometryReader { geo in
            if selectedCategory.items.count > 0 {
                HStack(spacing: 0) {
                    buttonPanel
                    
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
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 130))], spacing: 0) {
                    ForEach(selectedCategory.items) { item in
                        Button {
//                                cart.addItem(item)
                        } label: {
                            Text(item.name)
                                .modifier(TextMod(.title3, .semibold, .black))
                                .frame(width: geo.size.width * 0.18, height: 80)
                                .background(Color(XSS.ComplimentS.color70))
                        }
                        .cornerRadius(9)
                        .padding()
                        .shadow(radius: 8)
                    } //: ForEach
                } //: LazyVGrid
                Spacer()
            } //: VStack
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(XSS.S.color80))
            .cornerRadius(20, corners: [.topLeft, .topRight, .bottomRight])
        }
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
    }
}
