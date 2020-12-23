//
//  SalesHistoryView.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/22/20.
//

import SwiftUI
import RealmSwift

struct SalesHistoryView: View {
    @ObservedObject var appManager: AppStateManager
    
    var listWidth: CGFloat = 800
    
    var columnTitles: [String] = ["Timestamp", "No. Items", "Subtotal"]
    
    let allSales: Results<Sale> = try! Realm().objects(Sale.self)
    
    var body: some View {
        VStack {
            HeaderLabel(title: "Sales History")
            
            Spacer()
            
            VStack(alignment: .center, spacing: 0) {
                
                ListTitles(columnTitles: self.columnTitles, listWidth: self.listWidth)
                
                Divider().padding(.bottom, 10)
                
                List {
                    ForEach(self.allSales, id: \.self) { sale in
                        HStack {
                            Text("\(self.formatDate(date: sale.timestamp))")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(.black)
                                .frame(maxWidth: listWidth / 3, alignment: .leading)
                            
                            Text("\(sale.items.count) Items")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(.black)
                                .frame(maxWidth: listWidth / 3)
                            
                            Text("\(String(format: "%.2f", sale.total))")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(.black)
                                .frame(maxWidth: listWidth / 3, alignment: .trailing)
                        }
                        
                    }
                    .onDelete(perform: { indexSet in
//                        self.appManager.deleteItem(atOffsets: indexSet)
                    })
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .background(Color.white)

                } //: List
                
                Spacer()
            } //: VStack
            .frame(maxWidth: self.listWidth)
        } //: VStack
        .background(Color.white)
    }
    
    init(appManager: AppStateManager) {
        self.appManager = appManager
        for sale in allSales {
            print(formatDate(date: sale.timestamp))
        }
    }
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM. y - HH:mm"
        return dateFormatter.string(from: date)
    }
}
