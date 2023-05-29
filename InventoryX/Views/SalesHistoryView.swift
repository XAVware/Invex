

import SwiftUI
import RealmSwift

struct SalesHistoryView: View {
//    let saleDateManager: SaleDateManager = SaleDateManager()
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
            calendar.timeZone = TimeZone(secondsFromGMT: 0)!
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

    @State var rangeSales: [SaleEntity] = []
    
    var rangeTotal: Double {
        var tempTotal: Double = 0
//        if let rangeSales = rangeSales {
            for sale in rangeSales {
                tempTotal += sale.total
            }
//        }
        return tempTotal
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
                    RealmMinion.createRandomSales(qty: 100)
                } label: {
                    Text("Create 100 Random Sales")
                }

                HStack {
                    Text("Income \(selectedDateRange.rawValue): \(rangeTotal.formatToCurrencyString())")
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
                                
                List {
                    Section {
//                        if let rangeSales = salesInRange {
                            ForEach(rangeSales, id: \.self) { sale in
                                HStack {
                                    Text("\(sale.timestamp.formatted(date: .numeric, time: .shortened))")
                                    Spacer()
                                    Text(sale.total.formatToCurrencyString())
                                } //: HStack
                                .onTapGesture {
                                    isShowingDetail.toggle()
                                }
                            }
//                        } else {
//                            Text("No Sales")
//                        }
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
                updateSales(newRange: selectedDateRange)
                print(allSales)
            }
            .sheet(isPresented: $isShowingDetail) {
                SaleDetailView()
            }
            .onChange(of: selectedDateRange) { newValue in
                updateSales(newRange: newValue)
            }
        } //: GeometryReader
        
    } //: Body
    
}

struct SalesHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        SalesHistoryView()
            .modifier(PreviewMod())
    }
}


struct SaleRowView: View {
    @State var isExpanded: Bool = false
    @State var sale: SaleEntity
    
    var body: some View {
        GroupBox {
            DisclosureGroup(isExpanded: $isExpanded) {
                VStack {
                    Divider().padding(.vertical, 8)
                    
                    Text("Items: ")
                        .modifier(TextMod(.body, .semibold, .black))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack {
                        ForEach(sale.items, id: \.self) { saleItem in
                            HStack {
                                Image(systemName: "circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 10, height: 10)
                                
                                Text(saleItem.name)
                                    .modifier(TextMod(.body, .semibold, .black))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            } //: HStack
                            .padding(.horizontal)
                        } //: For Each
                    } //: VStack
                } //: VStack
                .foregroundColor(.black)
                
            } label: {
                Button {
                    withAnimation {
                        isExpanded.toggle()
                    }
                } label: {
                    HStack {
                        Text("\(formatDate(date: sale.timestamp))")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(sale.total.formatToCurrencyString())
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    } //: HStack
                    .modifier(TextMod(.body, .semibold, .black))
                    .foregroundColor(.black)
                } //: Button
            } //: DisclosureGroup
        } //: GroupBox
    }
    
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM. d y 'at' h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        return dateFormatter.string(from: date)
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
