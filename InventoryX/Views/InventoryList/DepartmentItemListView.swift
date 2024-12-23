//
//  DepartmentTableView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 5/23/24.
//

import SwiftUI
import RealmSwift


struct DepartmentItemListView: View {
    @Environment(NavigationService.self) var navService
    @Environment(InventoryViewModel.self) var vm
    @ObservedRealmObject var department: DepartmentEntity
    
    var body: some View {
        Section {
            sectionContent
        } header: {
            sectionHeader
        }
    }
    
    private var hasSelectedItems: Bool {
        !department.items.filter { vm.selectedItems.contains($0) }.isEmpty
    }
    
    private var sectionHeader: some View {
        VStack(alignment: .leading, spacing: 0) {
            @Bindable var vm = self.vm
            Menu {
                Button("Edit department", systemImage: "pencil") {
                    editDepartmentTapped(dept: department)
                }
                
                Button("Delete department", systemImage: "trash", role: .destructive) {
                    deleteDepartmentTapped(dept: department)
                }
            } label: {
                Text(department.name)
                    .font(.system(.title2, design: .rounded, weight: .semibold))
                
                Image(systemName: "ellipsis")
                    .rotationEffect(Angle(degrees: 90))
                
                
            }
            .padding(8)
            .alert("There are items in this department. Move them to a different department first.", isPresented: $vm.showingRemoveItemsFromDeptAlert) {
                Button("Okay", role: .cancel) { }
            }
            
            HStack(spacing: 12) {
                Button {
                    vm.multiSelect(department.items.map({ $0 }))
                } label: {
                    Image(systemName: hasSelectedItems ? "checkmark.square.fill" : "square")                        .foregroundStyle(Color.accentColor)
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
                    
                }
                .frame(maxWidth: .infinity)
                
                Text("")
                    .frame(maxWidth: 64, alignment: .trailing)
                
            } //: HStack
            .padding(.vertical, 12)
            .background(Color.bg300)
            .foregroundStyle(Color.textPrimary)
            .padding(.horizontal, 8)
            .font(.system(.callout, design: .rounded, weight: .regular))
            .roundedCornerWithBorder(lineWidth: 1, borderColor: Color.neoUnderDark.opacity(0.6), radius: 8, corners: [.topLeft, .topRight])
            
        } //: VStack
        .padding(.top)
        .background(Color.bg)
    } //: Section Header
    
    private var sectionContent: some View {
        VStack(spacing: 0) {
            @Bindable var vm = self.vm
            ForEach(department.items.sorted(by: \.name, ascending: true)) { item in
                HStack(spacing: 12) {
                    Button {
                        vm.multiSelect(item)
                    } label: {
                        Image(systemName: vm.selectedItems.contains(item) ? "checkmark.square.fill" : "square")
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
                    } //: HStack
                    
                    HStack {
                        Button("Edit", systemImage: "pencil") {
                            onSelect(item)
                        }
                        .fontWeight(.semibold)
                        .padding(8)
                        .background(Color.bg)
                        .modifier(RoundedOutlineMod(cornerRadius: 7, borderColor: Color.accentColor.opacity(0.07)))
                        
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
        .background(Color.bg200)
        .roundedCornerWithBorder(lineWidth: 1, borderColor: Color.neoUnderDark.opacity(0.6), radius: 8, corners: [.bottomLeft, .bottomRight])
    } //: Section Content
    
    private func deleteDepartmentTapped(dept: DepartmentEntity) {
        if dept.items.isEmpty {
            Task {
                await vm.deleteDepartment(withId: dept._id) { err in
                    print(err)
                }
            }
        } else {
            vm.showMoveItems()
        }
    }
    
    private func editDepartmentTapped(dept: DepartmentEntity) {
        navService.path.append(LSXDisplay.department(department))
    }
    
    private func onSelect(_ item: ItemEntity) {
        navService.path.append(LSXDisplay.item(item))
    }
}
