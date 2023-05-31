

import Charts
import SwiftUI
import RealmSwift

struct SalesHistoryView: View {
    var columnTitles: [String] = ["Timestamp", "No. Items", "Subtotal"]
    
    enum DateRanges: String, CaseIterable, Identifiable {
        var id: UUID {
            return UUID()
        }
        
        case today = "Today"
        case yesterday = "Yesterday"
        case thisWeek = "This Week"
        case lastWeek = "Last Week"
        
        var calendar: Calendar {
            var calendar = Calendar.current
            calendar.timeZone = TimeZone(abbreviation: "EDT")!
            calendar.firstWeekday = 1
            return calendar
        }

        var startOfToday: Date {
            return calendar.startOfDay(for: Date())
        }
        
        var endOfToday: Date {
            return calendar.date(bySettingHour: 23, minute: 59, second: 59, of: Date())!
        }
        
        var yesterday: Date {
            return calendar.date(byAdding: .day, value: -1 , to: Date())!
        }
        
        var startOfYesterday: Date {
            return calendar.startOfDay(for: yesterday)
        }
        
        var endOfYesterday: Date {
            return self.calendar.date(bySettingHour: 23, minute: 59, second: 59, of: self.yesterday)!
        }
        
        var thisWeek: [Date] {
            var week: [Date] = []
            if let weekInterval = self.calendar.dateInterval(of: .weekOfYear, for: Date()) {
                for i in 0...6 {
                    if let day = self.calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                        week.append(day)
                    }
                }
            }
            return week
        }
        
        var startOfThisWeek: Date {
            return self.thisWeek[0]
        }
        
        var endOfThisWeek: Date {
            let lastDay = self.thisWeek[self.thisWeek.count - 1]
            return self.calendar.date(bySettingHour: 23, minute: 59, second: 59, of: lastDay)!
        }
        
        var lastWeek: [Date] {
            let oneWeekAgo: Date = calendar.date(byAdding: .weekOfYear, value: -1, to: Date())!
            var week: [Date] = []
            if let weekInterval = self.calendar.dateInterval(of: .weekOfYear, for: oneWeekAgo) {
                for i in 0...6 {
                    if let day = self.calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                        week.append(day)
                    }
                }
            }
            return week
        }
        
        var startOfLastWeek: Date {
            return self.lastWeek[0]
        }
        
        var endOfLastWeek: Date {
            let lastDay = self.lastWeek[self.lastWeek.count - 1]
            return self.calendar.date(bySettingHour: 23, minute: 59, second: 59, of: lastDay)!
        }
    
        var realmPredicateForRange: NSPredicate {
            switch self {
            case .today:
                return NSPredicate(format: "timestamp BETWEEN {%@, %@}", startOfToday as NSDate, endOfToday as NSDate)
            case .yesterday:
                return NSPredicate(format: "timestamp BETWEEN {%@, %@}", startOfYesterday as NSDate, endOfYesterday as NSDate)
            case .lastWeek:
                return NSPredicate(format: "timestamp BETWEEN {%@, %@}", startOfLastWeek as NSDate, endOfLastWeek as NSDate)
            case .thisWeek:
                return NSPredicate(format: "timestamp BETWEEN {%@, %@}", startOfThisWeek as NSDate, endOfThisWeek as NSDate)
            }
        }
    }
    
    @State var selectedDateRange: DateRanges = DateRanges.today
    @State var isShowingDetail: Bool = false
    
    @ObservedResults(SaleEntity.self) var allSales

    @State var rangeSales: [SaleEntity] = [SaleEntity.todaySale1, SaleEntity.yesterdaySale1]
    
    var rangeTotal: Double {
        var tempTotal: Double = 0
        for sale in rangeSales {
            tempTotal += sale.total
        }
        return tempTotal
    }
 
    func getGroupedSales() -> [ChartData] {
        
        let chartData: [ChartData] = [
            ChartData(label: "4 AM", total: 0.0, hoursIncluded: [0, 1, 2, 3]),
            ChartData(label: "8 AM", total: 0.0, hoursIncluded: [4, 5, 6, 7]),
            ChartData(label: "12 PM", total: 0.0, hoursIncluded: [8, 9, 10, 11]),
            ChartData(label: "4 PM", total: 0.0, hoursIncluded: [12, 13, 14, 15]),
            ChartData(label: "8 PM", total: 0.0, hoursIncluded: [16, 17, 18, 19]),
            ChartData(label: "12 AM", total: 0.0, hoursIncluded: [20, 21, 22, 23])
        ]
        
        let groupedSales = groupSalesByHour(sales: rangeSales)
        
        for range in chartData {
            for hour in range.hoursIncluded {
                if let hourSales = groupedSales[hour] {
                    print("Sales Found for Hour \(hour)")
                    print(hourSales)
                    
                    for sale in hourSales {
                        range.total += sale.total
                    }
                }
            }
        }
        
        return chartData
    }
    
    func groupSalesByHour(sales: [SaleEntity]) -> [Int: [SaleEntity]] {
        var groupedSales: [Int: [SaleEntity]] = [:]

        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"

        for sale in sales {
            let hour = calendar.component(.hour, from: sale.timestamp)

            if var salesInHour = groupedSales[hour] {
                salesInHour.append(sale)
                groupedSales[hour] = salesInHour
            } else {
                groupedSales[hour] = [sale]
            }
        }

        return groupedSales
    }

    
    func updateSales(newRange: DateRanges) {
        var sales: [SaleEntity] = []
        let salesInRange = allSales.filter(selectedDateRange.realmPredicateForRange)
        salesInRange.forEach({ sale in
            let tempSale = SaleEntity(timestamp: sale.timestamp, total: sale.total)
            sales.append(tempSale)
        })
        rangeSales = sales
        
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Button {
//                    RealmMinion.createRandomSales(qty: 100)
                    RealmMinion.createRandomSalesToday(qty: 20)
                } label: {
                    Text("Create 100 Random Sales")
                }

                HStack {
                    Text("Income \(selectedDateRange.rawValue): \(rangeTotal.formatAsCurrencyString())")
                        .modifier(TextMod(.title3, .semibold, darkFgColor))
                    
                    Spacer()
                    
                    Text("Sales History")
                        .modifier(TextMod(.title3, .semibold, darkFgColor))
                    
                    Spacer()
                    
                    Picker(selection: $selectedDateRange) {
                        ForEach(DateRanges.allCases) { dateRange in
                            Text(dateRange.rawValue)
                                .tag(dateRange)
                        }
                    } label: {
                        Text("Range")
                    }
                    .tint(darkFgColor)
                    
                } //: HStack
                
                
                Chart {
                    ForEach(getGroupedSales()) { group in
                        BarMark(x: .value("Hour", group.label),
                                y: .value("Value", group.total))
                        .foregroundStyle(primaryBackground)
                        .cornerRadius(8)
                    }
                }
//                .chartXAxis {
//                    AxisMarks(values: .stride(by: .hour, count: 4)) { _ in
//                        AxisValueLabel(format: .dateTime.hour(.twoDigits(amPM: .abbreviated)))
//                    }
//                }
                .chartYAxis {
                    let totals = getGroupedSales().map { $0.total }
                    let min = totals.min() ?? 0.0
                    let maxTotal = totals.max() ?? 0.0
                    let maxMark = 20 * ceil(maxTotal / 20)
                    let costsStride = Array(stride(from: min, through: maxMark, by: 20))
                    AxisMarks(position: .leading, values: costsStride) { axis in
                        let value = costsStride[axis.index]
                        AxisValueLabel(value.formatAsCurrencyString(), centered: false)
                    }
                }
                .frame(maxWidth: 0.4 * geo.size.width, maxHeight: 0.3 * geo.size.height)
                                
                List {
                    Section {
                        ForEach(rangeSales, id: \.self) { sale in
                            HStack {
                                Text("\(sale.timestamp.formatted(date: .numeric, time: .shortened))")
                                Spacer()
                                Text(sale.total.formatAsCurrencyString())
                            } //: HStack
                            .onTapGesture {
                                isShowingDetail.toggle()
                            }
                        }
                    } header: {
                        Text("Sales")
                            .modifier(TextMod(.largeTitle, .semibold, .black))
                            .padding(.bottom, 8)
                            .textCase(nil)
                    }
                    .listRowBackground(Color.clear)
                }
                .scrollContentBackground(.hidden)
                .frame(maxWidth: 0.6 * geo.size.width)
                .background(lightFgColor)
                .cornerRadius(15)
                
            } //: VStack
            .padding()
            .background(secondaryBackground)
            .onAppear {
//                updateSales(newRange: selectedDateRange)
            }
            .sheet(isPresented: $isShowingDetail) {
                SaleDetailView()
            }
            .onChange(of: selectedDateRange) { newValue in
                updateSales(newRange: newValue)
            }
        } //: GeometryReader
        
    } //: Body
    
    class ChartData: Identifiable {
        let id: UUID = UUID()
        let label: String
        var total: Double
        let hoursIncluded: [Int]
        
        
        init(label: String, total: Double, hoursIncluded: [Int]) {
            self.label = label
            self.total = total
            self.hoursIncluded = hoursIncluded
        }
        
    }
    
}

struct SalesHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        SalesHistoryView()
            .modifier(PreviewMod())
    }
}


struct SaleDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25)
                        .padding(8)
                        .foregroundColor(.black)
                }
                
                Text("Sale Details")
                    .modifier(TextMod(.title, .semibold, .black))
                    .frame(maxWidth: .infinity)
                
                Spacer().frame(width: 25)
            } //: HStack
            
            Spacer()
        } //: VStack
        .padding()
        .background(Color(XSS.S.color90))
    }
}
