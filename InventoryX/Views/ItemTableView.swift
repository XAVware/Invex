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
// TODO: Is it okay for this view to re-initialize every time uiProperties changes?
struct ItemTableView: View {
    @ObservedResults(ItemEntity.self) var allItems
    @ObservedResults(DepartmentEntity.self) var allDepartments
    @Binding var department: DepartmentEntity?
    @State var style: TableViewStyle
//    let uiProperties: LayoutProperties
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
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    private var isCompact: Bool { horizontalSizeClass == .compact }

    @State var selectedRow: ItemEntity.ID?
    @State var selectedItem: ItemEntity?
    
    private var listView: some View {
        VStack {
            Table(of: ItemEntity.self, selection: $selectedRow) {
                TableColumn("Item Name") { item in
                    if isCompact {
                        Text(item.name)
                    } else {
                        Text(item.name)
                    }
                }
                
                TableColumn("Department") { item in
                    if let department = item.department.first {
                        Text(department.name)
                    } else {
                        Text("No department")
                    }
                }
                
                
                TableColumn("On hand qty") { item in
                    HStack {
                        Text((item.onHandQty < item.department.first?.restockNumber ?? .max) ? "⚠️" : "")
                            .frame(maxWidth: .infinity)
                        Text(String(describing: item.onHandQty))
                            .frame(maxWidth: .infinity)
                        Spacer()
                            .frame(maxWidth: .infinity)
                    } //: HStack
                }
                .width(min: 54, ideal: 80, max: 90)
                
                TableColumn("Price", value: \.formattedPrice)
                
                TableColumn("Cost", value: \.formattedUnitCost)
                
                TableColumn("") { item in
                    HStack(spacing: 16) {
                        Button {
                            self.selectedItem = item
                        } label: {
                            Image(systemName: "chevron.right")
                                .opacity(0.8)
                        }
                    } //: HStack
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .width(min: 72, ideal: 72, max: 72)
                
            } rows: {
                ForEach(allItems) { item in
                    TableRow(item)
                }
            }
            .modifier(TableStyleMod())
            .sheet(item: $selectedItem, onDismiss: {
                selectedItem = nil
                selectedRow = nil
            }) { item in
                AddItemView(item: item)
                    .overlay(AlertView())
            }
            .onChange(of: selectedRow) { newValue in
                guard let newValue = newValue else { return }
                if let item = allItems.first(where: { $0.id == newValue}) {
                    self.selectedItem = item
                }
            }
        } //: VStack
        
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
        
        // Minimum column count
        let finalColumnCount = max(rowCellCount, 2)
        gridColumns = Array(repeating: GridItem(.flexible(minimum: minButtonWidth, maximum: .infinity), spacing: gridSpacing), count: finalColumnCount)
    }
    
    @State var gridColumns: [GridItem] = [GridItem(.flexible(minimum: 120, maximum: 160))]
    
    private var gridView: some View {
        GeometryReader { geo in
            LazyVGrid(columns: gridColumns, alignment: .leading, spacing: gridSpacing) {
                ForEach(itemArr) { item in
                    Button {
                        onSelect(item)
                    } label: {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(item.name)
                                .font(.headline)
                                .foregroundStyle(.black)
                            Spacer()
                            Text(item.attribute)
                                .font(.subheadline)
                                .foregroundStyle(.black)
                                .opacity(0.8)
                            Spacer()
                            Text(item.retailPrice.formatAsCurrencyString())
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .foregroundStyle(.accent.opacity(0.8))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                    } //: VStack
                    .background(.ultraThinMaterial)
                    .background(Color("Purple050").opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(color: Color("Purple800").opacity(0.12), radius: 3, x: 2, y: 2)
                    .shadow(color: Color("Purple200").opacity(0.12), radius: 3, x: -2, y: -2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                } //: ForEach
                
            } //: LazyVGrid
            .padding(horPadding)
            .onAppear {
                recalcColumns(forWidth: geo.size.width)
                let realm = try! Realm()
                let sales = realm.objects(SaleEntity.self)
                sales.forEach { sale in
                    print(sale.items.first)
                }
            }
            .onChange(of: geo.size.width) { newValue in
                recalcColumns(forWidth: newValue)
            }
        } //: Geometry Reader
    }
    
}


#Preview {
    ResponsiveView { props in
        ItemTableView(department: .constant(nil), style: .list, onSelect: { item in
            
        })
        .padding()
        .environment(\.realm, DepartmentEntity.previewRealm)
    }
}
