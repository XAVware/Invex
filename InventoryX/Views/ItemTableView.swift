//
//  ItemTableView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/21/24.
//

import SwiftUI
import RealmSwift

struct ColumnHeaderModel: Identifiable {
    let id = UUID()
    let headerText: String
    let sortDescriptor: String
}

enum TableViewStyle: String, CaseIterable {
    case grid = "square.grid.2x2.fill"
    case list = "list.dash"
}

// TODO: Fix odd button animation when screen size changes
struct ItemTableView: View {
    @ObservedResults(ItemEntity.self) var allItems
    @Binding var department: DepartmentEntity?
    @State var style: TableViewStyle
    let onSelect: ((ItemEntity) -> Void)

    
    // TODO: Check if computed property is efficient here
        // -- This should not be done. Should probably pass the items into this view.
    // Can probably update a variable on change of department
    var itemArr: Array<ItemEntity> {
        if let dept = department { return Array(dept.items) }
        else { return Array(allItems) }
    }
    
    var body: some View {
        VStack {
            switch style {
            case .grid: gridView
            case .list: listView
            }
            Spacer()
        } //: VStack
        
    } //: Body
    
    
    // MARK: - LIST VIEW STYLE
    @State var columnData: [ColumnHeaderModel] = [
        ColumnHeaderModel(headerText: "Department", sortDescriptor: "dept"),
        ColumnHeaderModel(headerText: "Item Name", sortDescriptor: "name"),
        ColumnHeaderModel(headerText: "On-Hand", sortDescriptor: "onHandQty"),
        ColumnHeaderModel(headerText: "Retail Price", sortDescriptor: "retailPrice")
    ]
    
    @State var selectedItem: ItemEntity?
    
    private var listView: some View {
        VStack {
            HStack(spacing: 0) {
                ForEach(columnData) { header in
                    HStack {
                        Text(header.headerText)
                            .font(.body)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)

                    } //: HStack
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .frame(height: 64)
                    .background(Color("Purple050").opacity(0.5))
                }
                
            } //: HStack
            
            ForEach(itemArr) { item in
                HStack(spacing: 0) {
                    Text(item.department.thaw()?.first?.name ?? "")
                        .frame(maxWidth: .infinity)
                    
                    Text(item.name)
                        .frame(maxWidth: .infinity)
                                        
                    Text(item.onHandQty.description)
                        .frame(maxWidth: .infinity)
                    
                    Text(item.retailPrice.formatAsCurrencyString())
                        .frame(maxWidth: .infinity)

                } //: HStack
                .background(.white.opacity(0.01))
                .frame(height: 64)
                .onTapGesture {
                    selectedItem = item
                }

                Divider().opacity(0.4)
            } //: For Each
                
        } //: VStack
        .modifier(TableStyleMod())
        .sheet(item: $selectedItem) { item in
            AddItemView(item: item)
        }
    } //: List View
    
    
    // MARK: - GRID VIEW STYLE
    
    let minButtonWidth: CGFloat = 160
    let gridSpacing: CGFloat = 16
    let horPadding: CGFloat = 0
    
    func recalcColumns(forWidth width: CGFloat) {
        // Take the full available width and subtract any padding that's added to the table in this view. This leaves you with the maximum amount of space the buttons can use. Remember, padding is added to both sides of the table
        let availWidth = width - (horPadding * 2)
        
        // Divide by button width and round down to get how many buttons can fit in the available space.
        var rowCellCount = Int(floor(availWidth / minButtonWidth))
                
        // Get the number of interior column gaps (spacing) that would be required to display this number of buttons by subtracting 1 from the number of buttons. Get how much space the column gaps will consume by multiplying the gap count by the grid spacing.
        let totalGapSpace = (rowCellCount - 1) * Int(gridSpacing)
        
        // Get the total amount of space required to display the number of buttons with the requested gridSpacing. If the required amount is more than the available width (including padding), then return 1 less than the original column count.
        let totalSpaceRequired = Int(availWidth) + totalGapSpace
        
        if CGFloat(totalSpaceRequired) > availWidth {
            rowCellCount = rowCellCount - 1
        }
        
        let finalColumnCount = rowCellCount

        gridColumns = Array(repeating: GridItem(.flexible(minimum: minButtonWidth, maximum: .infinity), spacing: gridSpacing), count: finalColumnCount)
    }

    @State var gridColumns: [GridItem] = [GridItem(.flexible())]
    
    private var gridView: some View {
        GeometryReader { geo in
            LazyVGrid(columns: gridColumns, alignment: .leading, spacing: gridSpacing) {
                ForEach(itemArr) { item in
                    Button {
                        onSelect(item)
                    } label: {
                        VStack(spacing: 8) {
                            Text(item.name)
                                .font(.headline)
                                .frame(maxWidth: .infinity)
//                            Spacer()
                            Text(item.retailPrice.formatAsCurrencyString())
                                .font(.subheadline)
                                .frame(maxWidth: .infinity)
                        }
                        .padding(12)
                        .frame(minWidth: minButtonWidth, maxWidth: .infinity)
                        .foregroundStyle(.black)
                    } //: VStack
                    .modifier(ItemGridButtonMod())
                } //: ForEach

            } //: LazyVGrid
            .padding(horPadding)
            .onAppear {
                recalcColumns(forWidth: geo.size.width)
            }
            .onChange(of: geo.size.width) { newValue in
                recalcColumns(forWidth: newValue)
            }
        } //: Geometry Reader
    }
 
}


#Preview {
    ItemTableView(department: .constant(nil), style: .list, onSelect: { item in

    })
    .padding()
    .environment(\.realm, DepartmentEntity.previewRealm)
}
