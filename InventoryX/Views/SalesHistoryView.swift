

import SwiftUI
import RealmSwift

struct SalesHistoryView: View {
    let saleDateManager: SaleDateManager = SaleDateManager()
    var columnTitles: [String]          = ["Timestamp", "No. Items", "Subtotal"]
    var filters: [String]               = ["Today", "Yesterday", "This Week", "Last Week"]
    @State var selectedFilter: String   = "Today"
    
    
    var rangeSales: Results<SaleEntity> {
        switch selectedFilter {
        case "Today":
            return try! Realm().objects(SaleEntity.self).filter(NSPredicate(format: "timestamp BETWEEN {%@, %@}", self.saleDateManager.startOfToday as NSDate, self.saleDateManager.endOfToday as NSDate))
        case "Yesterday":
            return try! Realm().objects(SaleEntity.self).filter(NSPredicate(format: "timestamp BETWEEN {%@, %@}", self.saleDateManager.startOfYesterday as NSDate, self.saleDateManager.endOfYesterday as NSDate))
        case "This Week":
            return try! Realm().objects(SaleEntity.self).filter(NSPredicate(format: "timestamp BETWEEN {%@, %@}", self.saleDateManager.startOfThisWeek as NSDate, self.saleDateManager.endOfThisWeek as NSDate))
        case "Last Week":
            return try! Realm().objects(SaleEntity.self).filter(NSPredicate(format: "timestamp BETWEEN {%@, %@}", self.saleDateManager.startOfLastWeek as NSDate, self.saleDateManager.endOfLastWeek as NSDate))
        default:
            return try! Realm().objects(SaleEntity.self)
        }
    }
    
    var rangeTotal: Double {
        var tempTotal: Double = 0
        //        for sale in self.rangeSales {
        //            tempTotal += sale.total
        //        }
        return tempTotal
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Income \(selectedFilter): \(rangeTotal.formatToCurrencyString())")
                    .modifier(TextMod(.title3, .semibold, primaryColor))
                Spacer()
                Text("Sales History")
                    .modifier(TextMod(.title3, .semibold, primaryColor))
                Spacer()
                Picker(selection: $selectedFilter) {
                    ForEach(filters, id: \.self) { filter in
                        Text(filter)
                    }
                } label: {
                    Text("Range")
                }
                
            } //: HStack
            
            Spacer().frame(height: 20)
            
            Divider()
            
            HStack {
                Text("Timestamp")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Subtotal")
                    .frame(maxWidth: .infinity, alignment: .trailing)
            } //HStack: Titles
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ForEach(rangeSales, id: \.self) { sale in
                        SaleRowView(sale: sale)
                    }
                } //: VStack
            } //: ScrollView
            
        } //: VStack
        .padding()
        .background(Color(XSS.S.color80))
    } //: Body
    
}

struct SalesHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        SalesHistoryView()
            .modifier(PreviewMod())
    }
}


struct SaleRowView: View {
    @State var isExpanded: Bool     = false
    @State var sale: SaleEntity
    
    var body: some View {
        GroupBox {
            DisclosureGroup(isExpanded: self.$isExpanded) {
                VStack {
                    Divider().padding(.vertical, 8)
                    Text("Items: ")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack {
                        ForEach(self.sale.items, id: \.self) { saleItem in
                            HStack {
                                Image(systemName: "circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 10, height: 10)
                                Text(saleItem.name)
                                //                                Text("\(saleItem.name) \(saleItem.subtype == "" ? "x\(saleItem.qtyToPurchase)" : "- \(saleItem.subtype) x\(saleItem.qtyToPurchase)")")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.horizontal)
                        }
                    } //: VStack
                } //: VStack
                .foregroundColor(.black)
            } label: {
                Button(action: {
                    withAnimation {
                        self.isExpanded.toggle()
                    }
                }) {
                    HStack {
                        Text("\(self.formatDate(date: sale.timestamp))")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("$\(String(format: "%.2f", sale.total))")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    } //: HStack
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                } //: Button
            } //: DisclosureGroup
        } //: GroupBox
        .padding(.horizontal)
    }
    
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM. d y 'at' h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        return dateFormatter.string(from: date)
    }
}

