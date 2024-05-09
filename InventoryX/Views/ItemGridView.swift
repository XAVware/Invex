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

// TODO: Fix odd button animation when screen size changes
// TODO: Is it okay for this view to re-initialize every time uiProperties changes?
struct ItemGridView: View {
    let onSelect: ((ItemEntity) -> Void)
    let items: Array<ItemEntity>
    let minButtonWidth: CGFloat = 160
    let gridSpacing: CGFloat = 24
    let horPadding: CGFloat = 0
    
    func recalcColumns(forWidth width: CGFloat) {
        /// Take the full available width and subtract any padding that's added to the table 
        /// in this view. This leaves you with the maximum amount of space the buttons can use.
        /// Remember, padding is added to both sides of the table
        let availWidth = width - (horPadding * 2)
        
        /// Divide by button width and round down to get how many buttons can fit in the available space.
        var rowCellCount = Int(floor(availWidth / minButtonWidth))
        
        /// Get the number of interior column gaps (spacing) that would be required to display 
        /// this number of buttons by subtracting 1 from the number of buttons. Get how much
        /// space the column gaps will consume by multiplying the gap count by the grid spacing.
        let totalGapSpace = (rowCellCount - 1) * Int(gridSpacing)
        
        /// Get the total amount of space required to display the number of buttons with the 
        /// requested gridSpacing. If the required amount is more than the available width
        /// (including padding), then return 1 less than the original column count.
        let totalSpaceRequired = Int(availWidth) + totalGapSpace
        
        if CGFloat(totalSpaceRequired) > availWidth {
            rowCellCount = rowCellCount - 1
        }
        
        // Minimum column count
        let finalColumnCount = max(rowCellCount, 2)
        gridColumns = Array(repeating: GridItem(.flexible(minimum: minButtonWidth, maximum: .infinity), spacing: gridSpacing), count: finalColumnCount)
    }
    
    @State var gridColumns: [GridItem] = [GridItem(.flexible(minimum: 120, maximum: 160))]
    
    init(items: Array<ItemEntity>, onSelect: @escaping ((ItemEntity) -> Void)) {
        self.items = items
        self.onSelect = onSelect
    }
    
    var body: some View {
        ScrollView {
            VStack {
                GeometryReader { geo in
                    LazyVGrid(columns: gridColumns, alignment: .leading, spacing: gridSpacing) {
                        ForEach(items) { item in
                            Button {
                                onSelect(item)
                            } label: {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(item.name)
                                        .font(.headline)
                                        .foregroundStyle(Color("TextColor"))
                                    Spacer()
                                    Text(item.attribute)
                                        .font(.subheadline)
                                        .foregroundStyle(Color("TextColor"))
                                    Spacer()
                                    Text(item.retailPrice.formatAsCurrencyString())
                                        .font(.headline)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .foregroundStyle(.accent)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                            } //: VStack
                            .background(.ultraThinMaterial)
                            .background(Color("bgColor"))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(color: .accent.opacity(0.25), radius: 3, x: 2, y: 2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        } //: ForEach
                        
                    } //: LazyVGrid
                    .padding(horPadding)
                    .onAppear {
                        recalcColumns(forWidth: geo.size.width)
                    }
                    .onChange(of: geo.size.width) { _, newValue in
                        recalcColumns(forWidth: newValue)
                    }
                } //: Geometry Reader
                Spacer()
            } //: VStack
        } //: Scroll
    } //: Body
    
}


#Preview {
        ItemGridView(items: ItemEntity.drinkArray) { i in
            
        }
        .padding()
        .environment(\.realm, DepartmentEntity.previewRealm)
    
}
