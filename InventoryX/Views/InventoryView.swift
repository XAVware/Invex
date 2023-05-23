//
//  InventoryView.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 5/2/23.
//

import SwiftUI
import RealmSwift

struct InventoryView: View {
    @ObservedResults(InventoryItemEntity.self) var items
    @State var sortBy: String = "name"
    @State var isAscending: Bool = true
    @State var selectedItem: InventoryItemEntity?
    @State var isShowingDetailView: Bool = true
    
    func itemTapped(itemId: ObjectId) {
        let itemResult = items.where {
            $0._id == itemId
        }
        
        guard let item = itemResult.first else { return }
        
        selectedItem = item
    }
    
    func getItems() -> Results<InventoryItemEntity> {
        let observedItems = items.sorted(byKeyPath: sortBy, ascending: isAscending)
        return observedItems
    }
    
    func columnHeaderTapped(sortDescriptor: String) {
        if sortBy == sortDescriptor {
            isAscending.toggle()
        } else {
            sortBy = sortDescriptor
            isAscending = true
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            columnHeaders
            
            Divider()
            
            itemList
            
            Spacer()
        } //: VStack
            .background(Color(XSS.S.color90))
    } //: Body
    
    private var columnHeaders: some View {
        HStack(spacing: 0) {
            Button {
                columnHeaderTapped(sortDescriptor: "name")
            } label: {
                Text("Item Name")
                    .modifier(TextMod(.body, .semibold))
                
                if sortBy == "name" {
                    Image(systemName: "arrow.up")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 12)
                        .rotationEffect(Angle(degrees: isAscending ? 0 : 180))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
            Divider()
            
            Button {
                columnHeaderTapped(sortDescriptor: "onHandQty")
            } label: {
                Text("On-Hand")
                    .modifier(TextMod(.body, .semibold))
                
                if sortBy == "onHandQty" {
                    Image(systemName: "arrow.up")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 12)
                        .rotationEffect(Angle(degrees: isAscending ? 0 : 180))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
            Divider()
            
            Button {
                columnHeaderTapped(sortDescriptor: "retailPrice")
            } label: {
                Text("Retail Price")
                    .modifier(TextMod(.body, .semibold))
                
                if sortBy == "retailPrice" {
                    Image(systemName: "arrow.up")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 12)
                        .rotationEffect(Angle(degrees: isAscending ? 0 : 180))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
            Spacer().frame(width: 10)
        } //: HStack
        .frame(height: 50)
        .padding(.horizontal)
        .background(Color(XSS.S.color80))
        .modifier(TextMod(.body, .regular, .black))
    } //: Column Headers
    
    private var itemList: some View {
        ForEach(getItems().indices, id: \.self) { index in
            HStack(spacing: 0) {
                Text(getItems()[index].name)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Divider()
                
                Text(getItems()[index].onHandQty.description)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Divider()
                
                Text(String(format: "$ %.02f", getItems()[index].retailPrice))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.trailing)
                
                Image(systemName: "chevron.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10)
            } //: HStack
            .frame(height: 50)
            .padding(.horizontal)
            .background(index % 2 == 0 ? Color(XSS.S.color90) : Color(XSS.S.color80))
            .modifier(TextMod(.body, .regular, .black))
            .onTapGesture {
                itemTapped(itemId: getItems()[index]._id)
            }
        } //: ForEach
    } //: Item List
}

struct InventoryView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryView()
            .modifier(PreviewMod())
    }
}
