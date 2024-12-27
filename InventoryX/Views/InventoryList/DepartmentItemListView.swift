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
    @Environment(\.horizontalSizeClass) var hSize
    @ObservedRealmObject var department: DepartmentEntity
    
    var body: some View {
        Section {
            if department.items.isEmpty {
                noItemsRow
            } else {
                sectionContent
            }
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
            .alert("There are items in this department. Move them to a different department first.", isPresented: $vm.showingMoveItems) {
                Button("Okay", role: .cancel) { }
            }
            
            HStack(spacing: 12) {
                Button {
                    vm.multiSelect(department.items.map({ $0 }))
                } label: {
                    Image(systemName: hasSelectedItems ? "checkmark.square.fill" : "square")
                        .foregroundStyle(Color.accentColor)
                }
                .font(.system(.headline, design: .rounded, weight: .regular))
                
                HStack(spacing: 0) {
                    Text("Item")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    
                    if hSize == .regular {
                        Text("Attribute")
                            .frame(maxWidth: .infinity, alignment: .center)
                        Divider()
                    }
                    Text("Stock")
                        .frame(maxWidth: 100, alignment: .center)
                    Divider()
                    Text("Price")
                        .frame(maxWidth: 100, alignment: .trailing)
                    
                }
                .frame(maxWidth: .infinity)
                
                Text("")
                    .frame(maxWidth: 64, alignment: .trailing)
                
            } //: HStack
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
            .background(Color.bg300)
            .foregroundStyle(Color.textPrimary)
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
                        if hSize == .compact {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.headline)
                                Text(item.attribute)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.subheadline)
                            }
                        } else {
                            Text(item.name)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(item.attribute)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        Text(item.onHandQty.description)
                            .frame(maxWidth: 100, alignment: .center)
                            .foregroundStyle(item.showWarning ? Color.red : Color.textPrimary)
                        
                        Text(item.retailPrice.toCurrencyString())
                            .frame(maxWidth: 100, alignment: .trailing)
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
                .background(Color.bg200)
                .padding(.vertical)
                .padding(.horizontal, 8)
                .onTapGesture {
                    onSelect(item)
                }
                .environment(vm)
                
                Divider().opacity(0.4)
                
            }
        } //: VStack
        .background(Color.bg200)
        .roundedCornerWithBorder(lineWidth: 1, borderColor: Color.neoUnderDark.opacity(0.6), radius: 8, corners: [.bottomLeft, .bottomRight])
    } //: Section Content

    private var noItemsRow: some View {
        VStack {
            Text("No items yet. Tap the + button to add items.")
                .frame(maxWidth: .infinity)
                .italic()
                .padding(.vertical)
                .font(.callout)
                .fontWeight(.light)
        } //: VStack
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .background(Color.bg200)
        .foregroundStyle(Color.textPrimary)
        .roundedCornerWithBorder(lineWidth: 1, borderColor: Color.neoUnderDark.opacity(0.6), radius: 8, corners: [.bottomLeft, .bottomRight])
    }
    
    // MARK: - Functions
    private func deleteDepartmentTapped(dept: DepartmentEntity) {
        if dept.items.isEmpty {
            Task {
                await vm.deleteDepartment(withId: dept._id)
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
