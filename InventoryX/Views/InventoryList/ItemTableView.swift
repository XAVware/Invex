//
//  ItemTableView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 5/21/24.
//

import SwiftUI
import RealmSwift

@Observable
class ItemTableViewModel {
    var selectedItems: [ObjectId] = []
    
    func multiSelect(_ id: ObjectId) {
        if selectedItems.contains(id) {
            selectedItems.removeAll(where: { $0 == id })
        } else {
            selectedItems.append(id)
        }
    }
    
    func multiSelect(_ items: [ObjectId]) {
        if selectedItems.isEmpty {
            selectedItems.append(contentsOf: items)
        } else {
            selectedItems.removeAll()
        }
    }
    
    func deselectAll() {
        selectedItems.removeAll()
    }
    
}

struct ItemTableView: View {
    @Environment(NavigationService.self) var navService
    @ObservedResults(DepartmentEntity.self) var departments
    @State private var vm: ItemTableViewModel = .init()
    @State private var sortOrder: [KeyPathComparator<ItemEntity>] = []
    
    private var multiSelectPanel: some View {
        HStack {
            Button("Deselect All", systemImage: "xmark") {
                vm.deselectAll()
            }
            
            Spacer()
            
            Button {
                
            } label: {
                Text("Move...")
            }
            
            Divider()
            
            Button("Delete", systemImage: "trash", role: .destructive) {
                
            }

//            Spacer()
        }
        .padding()
        .background(Color.neoOverBg.shadow(radius: 2))
        .frame(maxWidth: .infinity, maxHeight: 48)
        
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
                ForEach(departments) { dept in
                    DepartmentSectionedView(department: dept)
                        .environment(vm)
                }
            } //: Lazy V
            .padding(8)
        } // ScrollView
        .navigationBarHidden(true)
        .background(.bg)
        .overlay(multiSelectPanel.padding(), alignment: .bottom)
    } //: Body
    
    
}

struct DepartmentSectionedView: View {
    @Environment(NavigationService.self) var navService
    @Environment(ItemTableViewModel.self) var vm
    @ObservedRealmObject var department: DepartmentEntity

    func onSelect(_ item: ItemEntity) {
        navService.path.append(LSXDisplay.item(item))
    }
    private var sectionContent: some View {
        VStack(spacing: 0) {
            
            
            ForEach(department.items.sorted(by: \.name, ascending: true)) { item in
                HStack(spacing: 12) {
                    Button {
                        vm.multiSelect(item._id)
                    } label: {
                        Image(systemName: vm.selectedItems.contains(item._id) ? "checkmark.square.fill" : "square")
                    }
                    .foregroundStyle(Color.accentColor)
                    
                    HStack(spacing: 0) {
                        Text(item.name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(item.attribute)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Text(item.onHandQty.description)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundStyle(item.showWarning ? Color.red : Color.textPrimary)
                        
                        Text(item.retailPrice.toCurrencyString())
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Text(item.unitCost.toCurrencyString())
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    HStack {
                        
                        Button("Edit", systemImage: "pencil", action: { onSelect(item) })
                            .fontWeight(.semibold)
                            .padding(8)
                            .background(Color.bg)
                            .modifier(RoundedOutlineMod(cornerRadius: 7, borderColor: Color.accentColor.opacity(0.07)))
                        
                        Button("Edit", systemImage: "ellipsis", action: { onSelect(item) })
                            .rotationEffect(Angle(degrees: 90))
                        
                    } //: HStack
                    .labelStyle(.iconOnly)
                    .font(.system(.headline, design: .rounded))
                    .frame(maxWidth: 64, alignment: .trailing)
                } //: HStack
                .padding(.vertical)
                .padding(.horizontal, 8)
                .environment(vm)
                
                    Divider().opacity(0.4)
                
            }
        } //: VStack
        .roundedCornerWithBorder(lineWidth: 1, borderColor: Color.neoUnderDark.opacity(0.6), radius: 8, corners: [.bottomLeft, .bottomRight])
        .background(Color.neoOverLight)
    }
    
    var body: some View {
        Section {
            sectionContent
        } header: {
            VStack(spacing: 0) {
                HStack {
                    Text(department.name)
                        .font(.system(.title2, design: .rounded, weight: .semibold))
                        .padding(.horizontal)
                    
                    Spacer()
                    Button("Department", systemImage: "gear", action: {
                        LSXService.shared.update(newDisplay: .department(department))
                    })
                    .labelStyle(.iconOnly)
                    .padding(8)
                } //: HStack
                .padding(.vertical, 8)
                
                //                Divider()
                
                HStack(spacing: 12) {
                    Button {
                        vm.multiSelect(department.items.map({$0._id}))
                    } label: {
                        Image(systemName: "square")
                            .foregroundStyle(Color.accentColor)
                    }
                    .font(.system(.headline, design: .rounded, weight: .regular))
                    
                    HStack(spacing: 0) {
                        Text("Item")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Attribute")
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Text("Stock")
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Text("Price")
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Text("Cost")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Text("Actions")
                        .frame(maxWidth: 64, alignment: .trailing)
                    
                } //: HStack
                .padding(.vertical, 12)
                .background(Color.bg)
                .foregroundStyle(Color.textPrimary)
                .padding(.horizontal, 8)
                .font(.system(.callout, design: .rounded, weight: .regular))
                .roundedCornerWithBorder(lineWidth: 1, borderColor: Color.neoUnderDark.opacity(0.6), radius: 8, corners: [.topLeft, .topRight])
                
            } //: VStack
            //            .padding(.horizontal, 8)
            //            .roundedCornerWithBorder(lineWidth: 1, borderColor: Color.neoUnderDark.opacity(0.6), radius: 8, corners: [.topLeft, .topRight])
            .padding(.top)
        }
    }
}


#Preview {
    InventoryListView()
        .environment(\.realm, DepartmentEntity.previewRealm)
        .environment(NavigationService())
}
