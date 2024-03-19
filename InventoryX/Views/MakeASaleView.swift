//
//  MakeASaleView.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 5/1/23.
//

import SwiftUI
import RealmSwift

struct MakeASaleView: View {
    let viewWidth: CGFloat
    @EnvironmentObject var vm: MakeASaleViewModel
    
    @ObservedResults(DepartmentEntity.self) var departments
    @ObservedResults(ItemEntity.self) var items
    
    /// When `selectedDepartment` is nil, the app displays all items in the view.
    @State var selectedDepartment: DepartmentEntity?
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 24) {
                // MARK: - DEPARTMENT SELECTOR
                ScrollView(.horizontal) {
                    HStack(spacing: 16) {
                        Button {
                            selectedDepartment = nil
                        } label: {
                            Text("All A-Z")
                                .modifier(DepartmentButtonMod(isSelected: selectedDepartment == nil))
                        }
                        
                        ForEach(departments) { department in
                            Button {
                                selectedDepartment = department
                            } label: {
                                Text(department.name)
                                    .modifier(DepartmentButtonMod(isSelected: selectedDepartment == department))
                            }
                        } //: For Each
                    } //: HStack
                } //: Scroll View
                .onAppear {
                    selectedDepartment = nil
                }
                
                if items.count == 0 {
                    // No items and no passcode means this is first time use. No items does not necessarily mean this is first time use because they could have set their passcode up then quit the app.
                    VStack {
                        Spacer()
                        Text("No Items Yet!")
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    ResponsiveView { props in
                        ItemTableView(viewWidth: viewWidth, selectedDepartment: $selectedDepartment) { item in
                            // If making a sale, add the item to cart. Otherwise select the item so it can be displayed in a add/modify item view.
                            vm.itemTapped(item: item)
                        }
                    }
                }
                
            } //: VStack
        }
    } //: Body
    
    
}

struct ItemTableView: View {
    let viewWidth: CGFloat
    @Binding var selectedDepartment: DepartmentEntity?
    let onSelect: ((ItemEntity) -> Void)
    
    let minButtonWidth: CGFloat = 120
    let gridSpacing: CGFloat = 16
    let horizontalTablePadding: CGFloat = 16
    
    @State var availableWidth: CGFloat = 0
    
    func getColCount(forWidth: CGFloat) {
        
    }
    
    private var numberOfColumns: Int {
        /// Return one less than the calculated count
        let columns = Float((availableWidth + gridSpacing) / (minButtonWidth + gridSpacing))
        return max(1, Int(columns - 1))
   }
    
    var gridColumns: [GridItem] {
        return Array(repeating: GridItem(.flexible(minimum: 120, maximum: .infinity), spacing: gridSpacing), count: numberOfColumns)
    }
    
    //TODO: Maybe pass items into this view?
    @ObservedResults(ItemEntity.self) var items
    
    var body: some View {
        GeometryReader { geo in
            LazyVGrid(columns: gridColumns, spacing: gridSpacing) {
                if let dept = selectedDepartment {
                    ForEach(dept.items, id: \.id) { item in
                        Button {
                            onSelect(item)
                        } label: {
                            VStack(spacing: 8) {
                                Text(item.name)
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                
                                Text(item.retailPrice.formatAsCurrencyString())
                                    .font(.subheadline)
                                    .frame(maxWidth: .infinity)
                            }
                            .foregroundStyle(.black)
                        } //: VStack
                        .frame(minWidth: minButtonWidth)
                        .padding(12)
                        .modifier(ItemGridButtonMod())
                    } //: ForEach
                } else {
                    // All items
                    ForEach(items, id: \.id) { item in
                        Button {
                            onSelect(item)
                        } label: {
                            VStack(spacing: 8) {
                                Text(item.name)
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                
                                Text(item.retailPrice.formatAsCurrencyString())
                                    .font(.subheadline)
                                    .frame(maxWidth: .infinity)
                            }
                            .foregroundStyle(.black)
                        } //: VStack
                        .frame(minWidth: minButtonWidth)
                        .padding(12)
                        .modifier(ItemGridButtonMod())
                    } //: ForEach
                } //: If-Else
            } //: LazyVGrid
            .onAppear {
                availableWidth = viewWidth
                print("width changed to \(viewWidth)")
            }
            .onChange(of: geo.size.width) { newValue in
                print("Width changed to: \(newValue)")
            }
        } //: Geometry Reader
    } //: Body

}

//struct MakeASaleView_Previews: PreviewProvider {
//    @State static var category: DepartmentEntity = DepartmentEntity.foodCategory
//    static var previews: some View {
//        MakeASaleView(selectedDepartment: category)
//            .padding()
//            .environmentObject(MakeASaleViewModel())
//            .environment(\.realm, DepartmentEntity.previewRealm)
//    }
//}
