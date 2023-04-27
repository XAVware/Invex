

import SwiftUI
import RealmSwift

struct SalesHistoryView: View {
    let saleDateManager: SaleDateManager = SaleDateManager()
    var columnTitles: [String]          = ["Timestamp", "No. Items", "Subtotal"]
    var filters: [String]               = ["Today", "Yesterday", "This Week", "Last Week"]
    @State var selectedFilter: String   = "Today"
    
    
    var rangeSales: Results<Sale> {
        switch selectedFilter {
        case "Today":
            return try! Realm().objects(Sale.self).filter(NSPredicate(format: "timestamp BETWEEN {%@, %@}", self.saleDateManager.startOfToday as NSDate, self.saleDateManager.endOfToday as NSDate))
        case "Yesterday":
            return try! Realm().objects(Sale.self).filter(NSPredicate(format: "timestamp BETWEEN {%@, %@}", self.saleDateManager.startOfYesterday as NSDate, self.saleDateManager.endOfYesterday as NSDate))
        case "This Week":
            return try! Realm().objects(Sale.self).filter(NSPredicate(format: "timestamp BETWEEN {%@, %@}", self.saleDateManager.startOfThisWeek as NSDate, self.saleDateManager.endOfThisWeek as NSDate))
        case "Last Week":
            return try! Realm().objects(Sale.self).filter(NSPredicate(format: "timestamp BETWEEN {%@, %@}", self.saleDateManager.startOfLastWeek as NSDate, self.saleDateManager.endOfLastWeek as NSDate))
        default:
            return try! Realm().objects(Sale.self)
        }
    }
    
    var rangeTotal: Double {
        var tempTotal: Double = 0
        for sale in self.rangeSales {
            tempTotal += sale.total
        }
        return tempTotal
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Sales History")
                .modifier(TitleModifier())
            
            Spacer().frame(height: 20)
            
            Divider()
            
            HStack(spacing: 0) {
                List {
                    ForEach(self.filters, id: \.self) { filter in
                        Button(action: {
                            self.selectedFilter = filter
                        }) {
                            HStack {
                                Text(filter)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 10, height: 15)
                            } //: HStack
                        } //: Button
                        .font(.system(size: 18, weight: self.selectedFilter == filter ? .semibold : .light, design: .rounded))
                        .foregroundColor(Color.black)
                        .frame(height: 50)
                        .padding(.horizontal)
                        .background(self.selectedFilter == filter ? Color.gray.opacity(0.8) : Color.clear)
                        
                    } //: ForEach
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    
                } //: List - Range Filters
                .frame(width: UIScreen.main.bounds.width * 0.30)
                
                Divider()
                
                VStack {
                    Text("Income:  $\(String(format: "%.2f", self.rangeTotal))")
                        .modifier(TitleModifier())
                    
                    HStack {
                        Text("Timestamp")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Subtotal")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    } //HStack: Titles
                    .modifier(DetailTextModifier(textColor: .black))
                    .padding(.trailing, 35)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            ForEach(self.rangeSales, id: \.self) { sale in
                                SaleRowView(sale: sale)
                            }
                        } //: VStack
                    } //: List
                } //: VStack
            } //: HStack
        } //: VStack
        
    }
}
