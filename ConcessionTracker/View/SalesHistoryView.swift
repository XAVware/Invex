//
//  SalesHistoryView.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/22/20.
//

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
                .padding()
            
            Spacer().frame(height: 30)
            
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
                                    .font(.system(size: 18, weight: self.selectedFilter == filter ? .semibold : .light, design: .rounded))
                                
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 10, height: 15)
                                    .font(.system(size: 18, weight: self.selectedFilter == filter ? .semibold : .light, design: .rounded))
                            }
                        } //: Button
                        .foregroundColor(Color.black)
                        .frame(height: 50)
                        .padding(.horizontal)
                        .background(self.selectedFilter == filter ? Color.gray.opacity(0.8) : Color.clear)
                    } //: ForEach
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    
                } //: List - Item Type
                .frame(width: UIScreen.main.bounds.width * 0.30)
                .background(Color.white)
                
                Divider()
                
                VStack {
                    
                    Text("Income:  $\(String(format: "%.2f", self.rangeTotal))")
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .foregroundColor(Color("ThemeColor"))
                    
                    HStack {
                        Text("Timestamp")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                            .opacity(0.7)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Subtotal")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                            .opacity(0.7)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    } //HStack: Titles
                    .padding(.leading, 32)
                    .padding(.trailing, 45)
                    List {
                        ForEach(self.rangeSales, id: \.self) { sale in
                            SaleRowView(sale: sale)
                        }
                        .listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                        .background(Color.white)
                        
                    } //: List
                    
                } //: VStack
                
            } //: HStack
            
        } //: VStack
        
    }
    
}
