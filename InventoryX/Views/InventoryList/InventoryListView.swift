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
    @ObservedResults(DepartmentEntity.self) var departments
    @State private var vm: InventoryViewModel = .init()
    @State private var sortOrder: [KeyPathComparator<ItemEntity>] = []
    @State var panelOffset: CGFloat = -48
    
    
    var body: some View {
//        VStack(spacing: 0) {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
                    ForEach(departments) { dept in
                        DepartmentItemListView(department: dept)
                            .environment(vm)
                    }
                } //: Lazy V
                .padding(8)
            } // ScrollView
//        } //: VStack
        .background(.bg)
        .overlay(multiSelectPanel.padding(), alignment: .top)
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
            Button("Deselect All", systemImage: "xmark", action: vm.deselectAll)
            Spacer()
            
            Menu("Move...") {
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
        .background(
            Color.neoOverBg
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(radius: 2)
        )
        .frame(maxWidth: 540, maxHeight: 48)
        .opacity(vm.selectedItems.isEmpty ? 0 : 1)
        .offset(y: panelOffset)
        .onChange(of: vm.selectedItems) { _, newValue in
            withAnimation(.bouncy(duration: 0.25)) {
                panelOffset = newValue.isEmpty ? -48 : 0
            }
        }
        
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
