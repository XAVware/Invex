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
    var showingMoveItems: Bool = false
    var showingDeleteAlert: Bool = false
    var showingRemoveItemsAlert: Bool = false
    
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
    
    func showMoveItems() {
        showingMoveItems = true
    }
    
    func showDeleteAlert() {
        showingDeleteAlert = true
    }
    
    func moveItemsTo(_ dept: DepartmentEntity) {
        
    }
    
    func deleteDepartment(withId id: RealmSwift.ObjectId, completion: @escaping ((Error?) -> Void)) async {
        do {
            try await RealmActor().deleteDepartment(id: id)
            completion(nil)
        } catch let error as AppError {
            completion(error)
        } catch {
            completion(error)
        }
    }
}

//struct ItemTableView: View {
//    @Environment(NavigationService.self) var navService
//    @ObservedResults(DepartmentEntity.self) var departments
//    @State private var vm: ItemTableViewModel = .init()
//    @State private var sortOrder: [KeyPathComparator<ItemEntity>] = []
//    @State var panelOffset: CGFloat = -96
//    private var multiSelectPanel: some View {
//        HStack(spacing: 16) {
//            Button("Deselect All", systemImage: "xmark", action: vm.deselectAll)
//            Spacer()
//            
//            Menu("Move...") {
//                Text("Select new department:")
//                ForEach(departments) { dept in
//                    Button(dept.name) {
//                        vm.moveItemsTo(dept)
//                    }
//                }
//            }
//
//            Divider()
//            
//            Button("Delete", systemImage: "trash", role: .destructive, action: vm.showDeleteAlert)
//                .alert("Are you sure?", isPresented: $vm.showingDeleteAlert) {
//                    Button("Go back", role: .cancel) { }
//                    Button("Yes, delete", role: .destructive) {
//                        
//                    }
//                }
//        } //: HStack
//        .padding()
//        .background(
//            Color.neoOverBg
//                .clipShape(RoundedRectangle(cornerRadius: 8))
//                .shadow(radius: 2)
//        )
//        .frame(maxWidth: 540, maxHeight: 48)
//        .offset(y: panelOffset)
//        .onChange(of: vm.selectedItems) { _, newValue in
//            withAnimation(.bouncy(duration: 0.25)) {
//                panelOffset = newValue.isEmpty ? -96 : 0
//            }
//        }
//    }
//    
//    var body: some View {
//        ScrollView(.vertical, showsIndicators: false) {
//            LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
//                ForEach(departments) { dept in
//                    DepartmentSectionedView(department: dept)
//                        .environment(vm)
//                }
//            } //: Lazy V
//            .padding(8)
//        } // ScrollView
//        .navigationBarHidden(true)
//        .background(.bg)
//        .overlay(multiSelectPanel.padding(), alignment: .top)
//    } //: Body
//    
//    
//}

struct DepartmentSectionedView: View {
    @Environment(NavigationService.self) var navService
    @Environment(ItemTableViewModel.self) var vm
    @ObservedRealmObject var department: DepartmentEntity
    
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
                        Button("Edit", systemImage: "pencil", action: {
                            onSelect(item)
                        })
                            .fontWeight(.semibold)
                            .padding(8)
                            .background(Color.bg)
                            .modifier(RoundedOutlineMod(cornerRadius: 7, borderColor: Color.accentColor.opacity(0.07)))
                        
                        Menu {
                            Button("Edit Item", systemImage: "pencil") {
                                onSelect(item)
                            }
                            
                            Button("Delete Item", systemImage: "trash", role: .destructive) {
                                
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .rotationEffect(Angle(degrees: 90))
                        }
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
    }
    
    var body: some View {
        @Bindable var vm = self.vm
        Section {
            sectionContent
        } header: {
            VStack(alignment: .leading, spacing: 0) {
//                HStack {
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
                    .alert("There are items in this department. Move them to a different department first.", isPresented: $vm.showingRemoveItemsAlert) {
                        Button("Okay", role: .cancel) { }
                    }
//                    Spacer()

//                } //: HStack
//                .padding(.vertical, 8)
                
                HStack(spacing: 12) {
                    Button {
                        vm.multiSelect(department.items.map({ $0._id }))
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
                .background(Color.bg300)
                .foregroundStyle(Color.textPrimary)
                .padding(.horizontal, 8)
                .font(.system(.callout, design: .rounded, weight: .regular))
                .roundedCornerWithBorder(lineWidth: 1, borderColor: Color.neoUnderDark.opacity(0.6), radius: 8, corners: [.topLeft, .topRight])
                
            } //: VStack
            .padding(.top)
            .background(Color.bg)
            
            
        }
    }
    
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


#Preview {
    InventoryListView()
        .environment(\.realm, DepartmentEntity.previewRealm)
        .environment(NavigationService())
}
