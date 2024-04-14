//
//  InventoryListView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 4/9/24.
//

import SwiftUI
import RealmSwift

/// Table is available iOS 16+

struct InventoryListView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @ObservedResults(ItemEntity.self) var allItems
    @ObservedResults(DepartmentEntity.self) var departments
    private var isCompact: Bool { 
        horizontalSizeClass == .compact
//        uiProperties.width < 750
    }
    
    @State var selectedRow: ItemEntity.ID?
//    @State var selectedDepartment: DepartmentEntity.ID?
    @State var selectedDepartment: DepartmentEntity?
    @State var selectedItem: ItemEntity?
    
    /// Used for small screens
    @State var columnData: [ColumnHeaderModel] = [
        ColumnHeaderModel(headerText: "Item", sortDescriptor: ""),
//        ColumnHeaderModel(headerText: "Dept.", sortDescriptor: ""),
        ColumnHeaderModel(headerText: "Stock", sortDescriptor: ""),
        ColumnHeaderModel(headerText: "Price", sortDescriptor: ""),
        ColumnHeaderModel(headerText: "Cost", sortDescriptor: "")
    ]
    
    let uiProperties: LayoutProperties
    
    var body: some View {
//        VStack {
//            if uiProperties.width < 750 {
//                compactTable
//            } else {
                fullTable
//            }
            
//        } //: VStack
        .font(isCompact ? .callout : .body)
        .onAppear {
            guard let dept = departments.first, !isCompact else { return }
//            selectedDepartment = dept.id
        }
        .onChange(of: selectedRow) { newValue in
            guard let newValue = newValue else { return }
            if let item = allItems.first(where: { $0.id == newValue}) {
                self.selectedItem = item
            }
        }
        .sheet(item: $selectedItem, onDismiss: {
            selectedItem = nil
            selectedRow = nil
            
        }) { item in
            AddItemView(item: item)
                .overlay(AlertView())
        }
    } //: Body
    
    // MARK: - COMPACT
//    private var compactTable: some View {
//        NavigationSplitView {
//            List(selection: $selectedDepartment, content: {
//                Text("Departments")
//                    .font(.title2)
//                    .padding(.vertical)
//                    .listRowSeparator(.hidden)
//                    .listRowBackground(Color.clear)
//                
//                ForEach(departments) { dept in
//                    Text(dept.name)
//                        .font(selectedDepartment == dept.id ? .headline : .subheadline)
//                        .listRowSeparator(.hidden)
//                        .listRowBackground(selectedDepartment == dept.id ? Color("Purple050").opacity(0.4) : Color.clear)
//                }
//            })
//            .listStyle(.plain)
//            .background(Color("Purple050").opacity(0.2))
////            .toolbar(.hidden, for: .navigationBar)
//        } detail: {
//            if let dept = departments.first(where: { $0.id == selectedDepartment }) {
//                // Headers for compact size class
//                HStack {
//                    ForEach(columnData) { header in
//                        Text(header.headerText)
//                            .font(.callout)
//                            .fontDesign(.rounded)
//                            .frame(maxWidth: .infinity, alignment: .leading)
////                            .frame(maxWidth: .infinity, alignment: header.id == columnData[0].id ? .leading : .center)
//                    }
//                    Spacer().frame(width: 24)
//                    
//                } //: HStack
//                .padding()
//                
//                Table(of: ItemEntity.self, selection: $selectedRow) {
//                    TableColumn("Name") { item in
//                        HStack {
//                            VStack(alignment: .leading, spacing: 8) {
//                                Text(item.name)
//                                    .fontWeight(.semibold)
//                                
//                                Text(item.attribute)
//                                    .fontWeight(.light)
//                                    .frame(maxWidth: .infinity)
//                            } //: VStack
//                            
////                            Spacer()
//                            Text(item.formattedQty)
//                                .frame(maxWidth: .infinity, alignment: .leading)
////                            Spacer()
//                            Text(item.formattedPrice)
//                                .frame(maxWidth: .infinity, alignment: .leading)
////                            Spacer()
//                            Text(item.formattedUnitCost)
//                                .frame(maxWidth: .infinity, alignment: .leading)
////                            Spacer()
//                            Text("⚠️")
//                        } //: HStack
//                    }
//                    
////                    TableColumn("Attribute", value: \.attribute)
////                    TableColumn("Price", value: \.formattedPrice).width(max: 128)
////                    TableColumn("Cost", value: \.formattedUnitCost).width(max: 128)
////                    TableColumn("Stock", value: \.formattedQty).width(max: 96)
////                    TableColumn("", value: \.restockWarning).width(max: 36)
//                } rows: {
//                    ForEach(dept.items) { item in
//                        TableRow(item)
//                    }
//                    
//                    
//                }
//                .scrollIndicators(.hidden)
//                .navigationDestination(for: ItemEntity.self, destination: { item in
//                    AddItemView(item: item)
//                })
////                .navigationDestination(item: $selectedItem) { item in
////                    AddItemView(item: item)
////                }
//            } else {
//                Text("Please select a department")
//            }
//                
//        }
//
//    } //: Compact Table
    
    private func itemRowTapped(_ item: ItemEntity) {
        selectedRow = item.id
    }
    
    // MARK: - FULL TABLE
    private var fullTable: some View {
        VStack {
            HStack {
                Text("Inventory")
                Spacer()
                Button {
                    selectedItem = ItemEntity()
                } label: {
                    Image(systemName: "plus")
                }
            } //: HStack
            .modifier(TitleMod())
            .padding()
            
//            if isCompact {
//                // Headers for compact size class
//                HStack(spacing: 8) {
//                    ForEach(columnData) { header in
//                        Text(header.headerText)
//                            .font(.callout)
//                            .fontDesign(.rounded)
//                            .frame(maxWidth: .infinity, alignment: header.id == columnData.first?.id ? .leading : .center)
//                    }
//                    Spacer().frame(width: 24)
//                    
//                } //: HStack
//                .padding(.horizontal)
//            }
            
//            if isCompact {
                HStack {
                    DepartmentPicker(departments: $departments, selectedDepartment: $selectedDepartment, style: .dropdown)
                        .font(.title3)
                    //                    .frame(maxHeight: 36)
                    Spacer()
                }
                .padding(.horizontal)
                .onAppear {
                    print(uiProperties.width)
                }
//            }
            
            Table(of: ItemEntity.self) {
                TableColumn("Item Name") { item in
                    if !isCompact {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .fontWeight(.semibold)
                            
                            
                            Text(item.attribute)
                                .fontWeight(.light)
//                                .frame(maxWidth: .infinity, alignment: .leading)
                        }// VStack
                        .padding(.vertical)
//                        .frame(maxWidth: .infinity, maxHeight: 48, alignment: .leading)
                        .background(.white.opacity(0.001))
                        .onTapGesture(perform: { itemRowTapped(item) })
                    } else {
                        // MARK: - COMPACT VIEW
                        HStack(spacing: 8) {
                            VStack(alignment: .leading) {
                                Text("Item:")
                                    .font(.caption)
                                Text(item.name)
                                    .fontWeight(.semibold)
                                Spacer()
                                Text("Attribute:")
                                    .font(.caption)
                                Text(item.attribute)
                                    .foregroundStyle(.primary)
                                    .fontWeight(.semibold)
                            } //: VStack
                            .frame(maxWidth: .infinity, alignment: .leading)

                            VStack(alignment: .leading) {
                                Text("On-hand:")
                                    .font(.caption)
                                Text(item.formattedQty)
                                    .foregroundStyle(.primary)
                                    .fontWeight(.semibold)
                                Spacer()
                            } //: VStack
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(alignment: .leading) {
                                Text("Price:")
                                    .font(.caption)
                                Text(item.formattedPrice)
                                    .fontWeight(.semibold)
                                Spacer()
                                Text("Cost:")
                                    .font(.caption)
                                Text(item.formattedUnitCost)
                                    .foregroundStyle(.primary)
                                    .fontWeight(.semibold)
                            } //: VStack
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            
                            
                            Image(systemName: "chevron.right")

                        } //: HStack
                        .font(.callout)
                        .padding()
                        .background(Color("Purple050").opacity(0.1))
                        .onTapGesture {
                            itemRowTapped(item)
                        }
                        .overlay(
                            Text(item.restockWarning)
                                .frame(maxWidth: 24, alignment: .trailing)
                            , alignment: .topTrailing)
                    }
                }
                .width(min: 128, max: uiProperties.width)
                
//                TableColumn("Department") { item in
//                    Text(item.departmentName)
//                        .padding(.vertical)
//                        .frame(maxWidth: .infinity, maxHeight: 48, alignment: .leading)
//                        .background(.white.opacity(0.001))
//                        .onTapGesture(perform: { itemRowTapped(item) })
//                }
                
                TableColumn("Stock") { item in
                    Text(item.formattedQty)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity, maxHeight: 48, alignment: .leading)
                        .background(.white.opacity(0.001))
                        .onTapGesture(perform: { itemRowTapped(item) })
                }
                .width(max: 96)
                
                TableColumn("Price") { item in
                    Text(item.formattedPrice)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity, maxHeight: 48, alignment: .leading)
                        .background(.white.opacity(0.001))
                        .onTapGesture(perform: { itemRowTapped(item) })
                }
                .width(max: 128)
                
                TableColumn("Cost") { item in
                    Text(item.formattedUnitCost)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity, maxHeight: 48, alignment: .leading)
                        .background(.white.opacity(0.001))
                        .onTapGesture(perform: { itemRowTapped(item) })
                }
                .width(max: 128)
                
                TableColumn("") { item in
                    Text(item.restockWarning)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity, maxHeight: 48, alignment: .leading)
                        .background(.white.opacity(0.001))
                        .onTapGesture(perform: { itemRowTapped(item) })
                }
                .width(max: 36)
                
            } rows: {
                if let dept = selectedDepartment {
                    ForEach(dept.items) { item in
                        TableRow(item)
                    }
                } else {
                    ForEach(allItems) { item in
                        TableRow(item)
                    }
                }
//                if selectedDepartment == nil {
//                    ForEach(allItems) { item in
//                        TableRow(item)
//                    }
//                } else {
//                    ForEach(
//                }
//                ForEach(allItems.where( {  $0.department._id == selectedDepartment?._id })) { item in
//                    TableRow(item)
//                }
            }
            .scrollIndicators(.hidden)
//            .modifier(TableStyleMod(sizeClass: horizontalSizeClass))

            
        }
    } //: Full Table
}

#Preview {
    ResponsiveView { props in
        InventoryListView(uiProperties: props)
            .environment(\.realm, DepartmentEntity.previewRealm)
        
            .onAppear {
//                let realm = try! Realm()
//                let objects = realm.objects(ItemEntity.self)
//                print(objects.first)
//                if let item = realm.objects(ItemEntity.self).first(where: { $0.name == ItemEntity.item1.name }) {
//                    try! realm.write({
//                        item.attribute = "Large"
//                    })
//                } else {
//                    print("Item not found")
//                }
//                    try! realm.write {
//                        realm.add(ItemEntity(name: "heresAReallyLongName", attribute: "itemAttribute", retailPrice: 4.0, avgCostPer: 2.0, onHandQty: 61))
//                    }
                }
    }
}
