////
////  SalesHistoryView.swift
////  InventoryX
////
////  Created by Ryan Smetana on 3/23/24.
////
//
//import SwiftUI
//
//
//
//import Charts
//import RealmSwift
//
//struct SalesHistoryView: View {
////    @EnvironmentObject var navMan: NavigationManager
//    var columnTitles: [String] = ["Timestamp", "No. Items", "Subtotal"]
//    
//    @State var selectedDateRange: DateRanges = DateRanges.today
//    @State var isShowingDetail: Bool = false
////    @State var selectedSale: SaleEntity?
//    
//    @ObservedResults(SaleEntity.self) var allSales
//
//    @State var rangeSales: [SaleEntity] = []
//    
//    var rangeTotal: Double {
//        var tempTotal: Double = 0
//        for sale in rangeSales {
//            tempTotal += sale.total
//        }
//        return tempTotal
//    }
// 
//    func getGroupedSales() -> [ChartData] {
//        let chartData: [ChartData] = [
//            ChartData(label: "4 AM", total: 0.0, hoursIncluded: [0, 1, 2, 3]),
//            ChartData(label: "8 AM", total: 0.0, hoursIncluded: [4, 5, 6, 7]),
//            ChartData(label: "12 PM", total: 0.0, hoursIncluded: [8, 9, 10, 11]),
//            ChartData(label: "4 PM", total: 0.0, hoursIncluded: [12, 13, 14, 15]),
//            ChartData(label: "8 PM", total: 0.0, hoursIncluded: [16, 17, 18, 19]),
//            ChartData(label: "12 AM", total: 0.0, hoursIncluded: [20, 21, 22, 23])
//        ]
//        
//        let groupedSales = groupSalesByHour(sales: rangeSales)
//        
//        for range in chartData {
//            for hour in range.hoursIncluded {
//                if let hourSales = groupedSales[hour] {
//                    for sale in hourSales {
//                        range.total += sale.total
//                    }
//                }
//            }
//        }
//        
//        return chartData
//    }
//    
//    func groupSalesByHour(sales: [SaleEntity]) -> [Int: [SaleEntity]] {
//        var groupedSales: [Int: [SaleEntity]] = [:]
//
//        let calendar = Calendar.current
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH"
//
//        for sale in sales {
//            let hour = calendar.component(.hour, from: sale.timestamp)
//
//            if var salesInHour = groupedSales[hour] {
//                salesInHour.append(sale)
//                groupedSales[hour] = salesInHour
//            } else {
//                groupedSales[hour] = [sale]
//            }
//        }
//
//        return groupedSales
//    }
//
//    
//    func updateSales(newRange: DateRanges) {
//        var sales: [SaleEntity] = []
//        let salesInRange = allSales.filter(selectedDateRange.realmPredicateForRange)
//        salesInRange.forEach({ sale in
//            let tempSale = SaleEntity(timestamp: sale.timestamp, total: sale.total)
//            sale.items.forEach({ item in
//                tempSale.items.append(item)
//            })
//            sales.append(tempSale)
//        })
//        rangeSales = sales
//        
//    }
//    
//    @State var selectedSale: SaleEntity?
//    
//    var body: some View {
//        NavigationSplitView(columnVisibility: .constant(.doubleColumn)) {
//            List(allSales) { sale in
//                HStack {
//                    Text("\(sale.timestamp.formatted(date: .numeric, time: .shortened))")
//                    Spacer()
//                    Text(sale.total.formatAsCurrencyString())
//                    Text("\(sale.items.count)")
//                } //: HStack
//                .onTapGesture {
//                    selectedSale = sale
//                }
//            }
//            .toolbar(.hidden, for: .navigationBar)
//        } detail: {
//            if let sale = self.selectedSale {
//                SaleDetailView(sale: sale)
//            }
//        }
//        .navigationSplitViewStyle(.balanced)
//
//    }
//    
//    
//    
////    var body: some View {
////        GeometryReader { geo in
////            VStack {
////                headerToolbar
////                    .frame(height: toolbarHeight)
////                    .padding(.bottom)
////                
////                Text("Income \(selectedDateRange.rawValue): \(rangeTotal.formatAsCurrencyString())")
////                    .font(.title3)
////                    .fontWeight(.semibold)
////                
////                Chart {
////                    ForEach(getGroupedSales()) { group in
////                        BarMark(x: .value("Hour", group.label),
////                                y: .value("Value", group.total))
////                        .foregroundStyle(.accent)
////                        .cornerRadius(8)
////                    }
////                }
////                .chartXAxis {
////                    AxisMarks(values: .stride(by: .hour, count: 4)) { _ in
////                        AxisValueLabel(format: .dateTime.hour(.twoDigits(amPM: .abbreviated)))
////                    }
////                }
////                .chartYAxis {
////                    let totals = getGroupedSales().map { $0.total }
////                    let min = totals.min() ?? 0.0
////                    let maxTotal = totals.max() ?? 0.0
////                    let maxMark = 20 * ceil(maxTotal / 20)
////                    let costsStride = Array(stride(from: min, through: maxMark, by: 20))
////                    AxisMarks(position: .leading, values: costsStride) { axis in
////                        let value = costsStride[axis.index]
////                        AxisValueLabel(value.formatAsCurrencyString(), centered: false)
////                    }
////                }
////                .frame(maxWidth: 0.4 * geo.size.width, maxHeight: 0.3 * geo.size.height)
//                                
////                List {
////                    Section {
////                        ForEach(rangeSales, id: \.self) { sale in
////                            HStack {
////                                Text("\(sale.timestamp.formatted(date: .numeric, time: .shortened))")
////                                Spacer()
////                                Text(sale.total.formatAsCurrencyString())
////                                Text("\(sale.items.count)")
////                            } //: HStack
////                            .onTapGesture {
////                                selectedSale = sale
////                                print(sale.items.count)
////                            }
////                        }
////                    } header: {
////                        Text("Sales")
////                            .font(.largeTitle)
////                            .fontWeight(.semibold)
////                            .padding(.bottom, 8)
////                            .textCase(nil)
////                    }
////                    .listRowBackground(Color.clear)
////                } //: List
////                .scrollContentBackground(.hidden)
////                .frame(maxWidth: 0.6 * geo.size.width)
////                .background(Color("bgColor"))
////                .cornerRadius(15)
////                
////            } //: VStack
////            .padding()
////            .background(Color("bgColor"))
////            .onAppear {
////                updateSales(newRange: selectedDateRange)
////            }
////            .sheet(item: $selectedSale, onDismiss: {
////                selectedSale = nil
////            }, content: { sale in
////                SaleDetailView(sale: sale)
////            })
////            .onChange(of: selectedDateRange) { newValue in
////                updateSales(newRange: newValue)
////            }
////        } //: GeometryReader
////        
////    } //: Body
//    
//    private var headerToolbar: some View {
//        HStack(spacing: 24) {
//            Button {
////                navMan.toggleMenu()
//            } label: {
//                Image(systemName: "sidebar.squares.leading")
//                    .resizable()
//                    .scaledToFit()
//                    .foregroundColor(.accentColor)
//            }
//            
//            Spacer()
//            
//            Text("Sales History")
//                .font(.title3)
//                .fontWeight(.semibold)
//            
//            Spacer()
//            
//            Picker(selection: $selectedDateRange) {
//                ForEach(DateRanges.allCases) { dateRange in
//                    Text(dateRange.rawValue)
//                        .tag(dateRange)
//                }
//            } label: {
//                Text("Range")
//            }
//        } //: HStack
//        .frame(height: toolbarHeight)
//        .padding(.horizontal)
//    } //: Header Toolbar
//    
//    let toolbarHeight: CGFloat = 24
//    
//    class ChartData: Identifiable {
//        let id: UUID = UUID()
//        let label: String
//        var total: Double
//        let hoursIncluded: [Int]
//        
//        
//        init(label: String, total: Double, hoursIncluded: [Int]) {
//            self.label = label
//            self.total = total
//            self.hoursIncluded = hoursIncluded
//        }
//        
//    }
//    
//}
//
//
//#Preview {
//    SalesHistoryView()
//}
