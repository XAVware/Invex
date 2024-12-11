//
//  InventoryListView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 4/9/24.
//

import SwiftUI
import RealmSwift


struct InventoryListView: View {
    @Environment(NavigationService.self) var navService
    @ObservedResults(DepartmentEntity.self) var departments
    @State private var vm: ItemTableViewModel = .init()
    @State private var sortOrder: [KeyPathComparator<ItemEntity>] = []
    @State var panelOffset: CGFloat = -48
    
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
                .alert("Are you sure?", isPresented: $vm.showingDeleteAlert) {
                    Button("Go back", role: .cancel) { }
                    Button("Yes, delete", role: .destructive) {
                        
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
        
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Inventory")
                    .font(.largeTitle)
                    .fontDesign(.rounded)
                    .padding(.top, 4)
                Spacer()
                Menu {
                    Button("Add Item") {
                        navService.path.append(LSXDisplay.item(ItemEntity()))
                    }
                    
                    Button("Add Department") {
                        navService.path.append(LSXDisplay.department(DepartmentEntity()))
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(.title)
                }
            }
            .padding()
            .frame(maxHeight: 48)
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
                    ForEach(departments) { dept in
                        DepartmentSectionedView(department: dept)
                            .environment(vm)
                    }
                } //: Lazy V
                .padding(8)
            } // ScrollView
        } //: VStack
        .navigationBarHidden(true)
        .background(.bg)
        .overlay(multiSelectPanel.padding(), alignment: .top)
        .onAppear {
            departments.forEach { dept in
                print(dept.items.count)
                print(dept.items)
            }
        }
    } //: Body
    
}

#Preview {
    InventoryListView()
        .environment(\.realm, DepartmentEntity.previewRealm)
        .environment(NavigationService())
}
