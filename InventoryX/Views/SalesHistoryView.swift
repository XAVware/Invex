

import SwiftUI
import RealmSwift

struct SalesHistoryView: View {
    let saleDateManager: SaleDateManager = SaleDateManager()
    var columnTitles: [String] = ["Timestamp", "No. Items", "Subtotal"]
    var filters: [String] = ["Today", "Yesterday", "This Week", "Last Week"]
    @State var selectedFilter: String = "Today"
    @State var isShowingDetail: Bool = false
    
//    @ObservedResults(SaleEntity.self) var sales
    
    //For Testing
    var sales: [SaleEntity] = [SaleEntity.todaySale1, SaleEntity.yesterdaySale1]
    
//    var rangeSales: Results<SaleEntity> {
//        switch selectedFilter {
//        case "Today":
//            return try! Realm().objects(SaleEntity.self).filter(NSPredicate(format: "timestamp BETWEEN {%@, %@}", self.saleDateManager.startOfToday as NSDate, self.saleDateManager.endOfToday as NSDate))
//        case "Yesterday":
//            return try! Realm().objects(SaleEntity.self).filter(NSPredicate(format: "timestamp BETWEEN {%@, %@}", self.saleDateManager.startOfYesterday as NSDate, self.saleDateManager.endOfYesterday as NSDate))
//        case "This Week":
//            return try! Realm().objects(SaleEntity.self).filter(NSPredicate(format: "timestamp BETWEEN {%@, %@}", self.saleDateManager.startOfThisWeek as NSDate, self.saleDateManager.endOfThisWeek as NSDate))
//        case "Last Week":
//            return try! Realm().objects(SaleEntity.self).filter(NSPredicate(format: "timestamp BETWEEN {%@, %@}", self.saleDateManager.startOfLastWeek as NSDate, self.saleDateManager.endOfLastWeek as NSDate))
//        default:
//            return try! Realm().objects(SaleEntity.self)
//        }
//    }
    
    var rangeTotal: Double {
        var tempTotal: Double = 0
        //        for sale in self.rangeSales {
        //            tempTotal += sale.total
        //        }
        return tempTotal
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack {
                    Text("Income \(selectedFilter): \(rangeTotal.formatToCurrencyString())")
                        .modifier(TextMod(.title3, .semibold, lightFgColor))
                    
                    Spacer()
                    
                    Text("Sales History")
                        .modifier(TextMod(.title3, .semibold, lightFgColor))
                    
                    Spacer()
                    
                    Picker(selection: $selectedFilter) {
                        ForEach(filters, id: \.self) { filter in
                            Text(filter)
                        }
                    } label: {
                        Text("Range")
                    }
                    
                } //: HStack
                                
                List {
                    Section {
                        ForEach(sales, id: \.self) { sale in
                            HStack {
                                Text("\(sale.timestamp)")
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
            .sheet(isPresented: $isShowingDetail) {
                SaleDetailView()
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
