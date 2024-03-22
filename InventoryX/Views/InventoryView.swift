//
//  InventoryView.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 5/2/23.
//

import SwiftUI
import RealmSwift

struct ColumnHeaderModel: Identifiable {
    let id = UUID()
    let headerText: String
    let sortDescriptor: String
}

struct InventoryView: View {
    @EnvironmentObject var navMan: NavigationManager
    @ObservedResults(ItemEntity.self) var items
    //    @State var selectedItem: InventoryItemEntity?
    //    @State var isShowingDetailView: Bool = false
    
    @State var sortBy: String = "name"
    @State var isAscending: Bool = true
    @State var columnData: [ColumnHeaderModel] = [ColumnHeaderModel(headerText: "Item Name", sortDescriptor: "name"),
                                                  ColumnHeaderModel(headerText: "On-Hand", sortDescriptor: "onHandQty"),
                                                  ColumnHeaderModel(headerText: "Retail Price", sortDescriptor: "retailPrice")]
    
    func itemTapped(itemId: ObjectId) {
        let itemResult = items.where {
            $0._id == itemId
        }
        
        guard let item = itemResult.first else { return }
        
        //        selectedItem = item
        navMan.inventoryListItemSelected(item: item)
    }
    
    func getItems() -> Results<ItemEntity> {
        let observedItems = items.sorted(byKeyPath: sortBy, ascending: isAscending)
        return observedItems
    }
    
    func columnHeaderTapped(sortDescriptor: String) {
        
    }
    
    var body: some View {
        VStack(spacing: 0) {
            headerToolbar
                .frame(height: toolbarHeight)
                .padding(.bottom)
            
            columnHeaders
            
            Divider()
            
            itemList
            
            Spacer()
        } //: VStack
        .background(Theme.lightFgColor)
        
    } //: Body
    
    private var headerToolbar: some View {
        HStack(spacing: 24) {
            Button {
                navMan.toggleMenu()
            } label: {
                Image(systemName: "sidebar.squares.leading")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Theme.primaryBackground)
            }
            Spacer()
            
            Button {
                // Restock
            } label: {
                Image(systemName: "tray.and.arrow.down")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Theme.primaryBackground)
            } //: Button
            
            Button {
                navMan.inventoryListItemSelected(item: nil)
            } label: {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Theme.primaryBackground)
            } //: Button
        } //: HStack
        .modifier(TextMod(.body, .light, Theme.primaryBackground))
        .frame(height: toolbarHeight)
        .padding(.horizontal)
    } //: Header Toolbar
    
    private var columnHeaders: some View {
        HStack(spacing: 0) {
            
            ForEach(columnData) { header in
                HStack {
                    Text(header.headerText)
                        .font(.body)
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)
                    
                    if sortBy == header.sortDescriptor {
                        Image(systemName: "arrow.up")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 12)
                            .rotationEffect(Angle(degrees: isAscending ? 0 : 180))
                    }
                } //: HStack
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .onTapGesture {
                    if sortBy == header.sortDescriptor {
                        isAscending.toggle()
                    } else {
                        sortBy = header.sortDescriptor
                        isAscending = true
                    }
                }
                
                Divider()
            }
            
        } //: HStack
        .frame(height: 50)
        .background(Theme.primaryColor.opacity(0.1))
//        .modifier(TextMod(.body, .regular, .black))
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
                
                Text(getItems()[index].retailPrice.formatAsCurrencyString())
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.trailing)
                
                Image(systemName: "chevron.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10)
            } //: HStack
            .frame(height: 50)
            .padding(.horizontal)
            .background(index % 2 == 0 ? Theme.primaryColor.opacity(0.05) : nil)
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
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (4th generation)"))
            .previewInterfaceOrientation(.landscapeLeft)
            .environmentObject(NavigationManager())
    }
}
