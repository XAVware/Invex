////
////  DepartmentsView.swift
////  InventoryX
////
////  Created by Ryan Smetana on 3/20/24.
////
//
//import SwiftUI
//import RealmSwift
//
//
//struct DepartmentsView: View {
//    @Environment(\.horizontalSizeClass) var horizontalSizeClass
//    @ObservedResults(DepartmentEntity.self) var departments
//    @State var selectedDepartment: DepartmentEntity?
//    @State var selectedRow: DepartmentEntity.ID?
//    private var isCompact: Bool { horizontalSizeClass == .compact }
//    
//    /// Used for small screens
//    @State var columnData: [ColumnHeaderModel] = [
//        ColumnHeaderModel(headerText: "Department", sortDescriptor: "dept"),
//        ColumnHeaderModel(headerText: "", sortDescriptor: "name"),
//        ColumnHeaderModel(headerText: "Markup", sortDescriptor: "onHandQty")
//    ]
//    
//    var body: some View {
//        VStack {
//            HStack {
////                Text("Departments")
//                Spacer()
//                Button {
//                    selectedDepartment = DepartmentEntity()
//                } label: {
//                    Image(systemName: "plus")
//                }
//            } //: HStack
//            .padding()
//            .font(.title2)
//            .fontDesign(.rounded)
//            
//            if isCompact {
//                // Headers for compact size class
//                HStack(spacing: 0) {
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
//            
//            Table(of: DepartmentEntity.self, selection: $selectedRow) {
//                TableColumn("Departments") { dept in
//                    if isCompact {
//                        HStack(spacing: 0) {
//                            Text(dept.name)
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                            Text("\(dept.items.count.description) Items")
//                                .frame(maxWidth: .infinity)
//                            Text(dept.defMarkup.toPercentageString())
//                                .frame(maxWidth: .infinity)
//                            Button {
//                                self.selectedDepartment = dept
//                            } label: {
//                                Image(systemName: "chevron.right")
//                                    .opacity(0.8)
//                            }
//                            .frame(width: 24)
//                        }
//                        
//                    } else {
//                        Text("\(dept.items.count.description) Items")
//                        
//                    }
//                }
//                
//                TableColumn("Items") { dept in
//                    Text("\(dept.items.count.description) Items")
//                }
//                
//                TableColumn("Total liquidity") { dept in
//                    let total: Double = dept.items.reduce(0) { $0 + ($1.retailPrice * Double($1.onHandQty)) }
//                    Text(total.formatAsCurrencyString())
//                }
//                
//                TableColumn("Markup %") { dept in
//                    Text(dept.defMarkup.toPercentageString())
//                }
//                
//                
//            } rows: {
//                ForEach(departments) { dept in
//                    TableRow(dept)
//                }
//            }
//            .modifier(TableStyleMod())
//            .scrollIndicators(.hidden)
//            .sheet(item: $selectedDepartment) {
//                // On dismiss
//                selectedDepartment = nil
//                selectedRow = nil
//            } content: { dept in
//                DepartmentDetailView(department: dept)
//                    .overlay(AlertView())
//            }
//            .onChange(of: selectedRow) { _, newValue in
//                guard let newValue = newValue else { return }
//                if let dept = departments.first(where: { $0.id == newValue}) {
//                    self.selectedDepartment = dept
//                }
//            }
//        } //: VStack
//        .font(isCompact ? .callout : .body)
//
//    } //: Body
//    
//    
//}
//
//#Preview {
//    ResponsiveView { props in
//            DepartmentsView()
//                .environment(\.realm, DepartmentEntity.previewRealm)
//        
//    }
//}
//
//
//
