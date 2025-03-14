//
//  InventoryListView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 4/9/24.
//

import SwiftUI
import RealmSwift

struct InventoryListView: View {
    private enum EntityType { case item, department }
    @Environment(NavigationService.self) var navService
    @Environment(\.horizontalSizeClass) var hSize
    @ObservedResults(DepartmentEntity.self) var departments
    @State private var vm: InventoryViewModel = .init()
//    @State private var sortOrder: [KeyPathComparator<ItemEntity>] = []
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
                ForEach(departments) { dept in
                    DepartmentItemListView(department: dept)
                        .environment(vm)
                }
            } //: Lazy V
            .padding(8)
            .clipped()
        } // ScrollView
        .navigationTitle("Inventory")
        .background(Color.bg100)
        .overlay(multiSelectPanel, alignment: .bottom)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("Add Item") {
                        addTapped(type: .item)
                    }
                    
                    Button("Add Department") {
                        addTapped(type: .department)
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    } //: Body
    
    private var multiSelectPanel: some View {
        HStack(spacing: 16) {
            Button("Deselect", systemImage: "xmark", action: vm.deselectAll)
            Spacer()
            Menu("Move...", systemImage: "rectangle.portrait.and.arrow.right") {
                Text("Select new department:")
                ForEach(departments) { dept in
                    Button(dept.name) {
                        vm.moveItemsTo(dept)
                    }
                }
            }
            
            Divider()
            
            Button("Delete", systemImage: "trash", role: .destructive, action: vm.showDeleteAlert)
                .alert("Delete these items?", isPresented: $vm.showingDeleteAlert) {
                    Button("Go back", role: .cancel) { }
                    Button("Yes, delete", role: .destructive) {
                        Task {
                            vm.deleteSelectedItems()
                        }
                    }
                }
        } //: HStack
        .padding()
        .background(.thinMaterial)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.accentColor.opacity(0.2), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: Color.textDark.opacity(0.15), radius: 3)
        .frame(maxWidth: 540, maxHeight: 48)
        .opacity(vm.selectedItems.isEmpty ? 0 : 1)
        .offset(y: vm.selectedItems.isEmpty ? 96 : -12)
        .animation(.interactiveSpring, value: vm.selectedItems.isEmpty)
        .padding()
    } //: Multi Select Panel
    
    private func addTapped(type: EntityType) {
        if type == .item {
            navService.path.append(LSXDisplay.item(ItemEntity()))
        } else if type == .department {
            navService.path.append(LSXDisplay.department(DepartmentEntity()))
        }
    }
}


#Preview {
    InventoryListView()
        .environment(\.realm, DepartmentEntity.previewRealm)
        .environment(NavigationService())
}
