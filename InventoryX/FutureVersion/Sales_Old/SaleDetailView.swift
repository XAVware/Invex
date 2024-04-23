////
////  SaleDetailView.swift
////  InventoryX
////
////  Created by Ryan Smetana on 6/2/23.
////
//
//import SwiftUI
//import RealmSwift
//
//struct SaleDetailView: View {
//    @Environment(\.dismiss) var dismiss
//    @State var sale: SaleEntity
//    
////    private func getSubtotal(item: ItemEntity) -> Double {
////        let price: Double = item.retailPrice
////        let quantity: Double = Double(item.qtyToPurchase)
////        return price * quantity
////    }
//    
//    var body: some View {
//        VStack(spacing: 16) {
//            Text("Sale Details")
//                .font(.largeTitle)
//                .fontWeight(.semibold)
//                .frame(maxWidth: .infinity)
//                .padding(.top)
//            
//            Divider()
//            
//            HStack {
//                VStack(alignment: .leading) {
//                    Text("Cashier:")
//                    
//                    Text(sale.cashierName)
//                } //: VStack
//                .font(.title2)
//                .fontWeight(.semibold)
//                
//                Spacer()
//                    
//                VStack(alignment: .leading) {
//                    Text("Timestamp:")
//                    Text(sale.timestamp.formatted(date: .abbreviated, time: .shortened))
//                }
//                .font(.title2)
//                .fontWeight(.semibold)
//            } //: HStack
//            .padding()
//            
//            HStack(spacing: 16) {
//                Text("Total:")
//                    .font(.title)
//                    .fontWeight(.semibold)
//                    .foregroundStyle(.gray)
//                
//                Text(sale.total.formatAsCurrencyString())
//            } //: HStack
//            
//            VStack(spacing: 0) {
//                HStack {
//                    Text("Item Name:")
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                    
//                    Text("Quantity Sold:")
//                        .frame(maxWidth: .infinity, alignment: .center)
//                    
//                    Text("Item Price:")
//                        .frame(maxWidth: .infinity, alignment: .center)
//                    
//                    Text("Item Subtotal:")
//                        .frame(maxWidth: .infinity, alignment: .trailing)
//                } //: HStack
//                .frame(height: 50)
//                .padding(.horizontal)
//                .background(Color("Purple050").opacity(0.6))
//                
//                ScrollView(.vertical, showsIndicators: false) {
//                    ForEach(sale.items) { item in
//                        HStack(spacing: 0) {
//                            Text(item.name)
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                            
//                            Divider()
//                            
////                            Text("\(sale.items[index].qtyToPurchase)")
////                                .frame(maxWidth: .infinity, alignment: .center)
//                            
//                            Divider()
//                            
//                            Text(item.retailPrice.formatAsCurrencyString())
//                                .frame(maxWidth: .infinity, alignment: .center)
//                            
//                            Divider()
//                            
//                            //                            Text(getSubtotal(item: sale.items[index]).formatAsCurrencyString())
//                            //                                .frame(maxWidth: .infinity, alignment: .trailing)
//                        } //: HStack
//                        .frame(height: 50)
//                        .padding(.horizontal)
//                        .background(Color("Purple050").opacity(0.6))
//                        
//                    }
//                } //: ScrollView
//            } //: VStack
//            .padding(.top)
//            
//            Spacer()
//        } //: VStack
//        .overlay(
//            Button {
//                dismiss()
//            } label: {
//                Image(systemName: "xmark")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 24)
//                    .foregroundColor(.black)
//            }
//            .padding()
//            , alignment: .topLeading)
//        .background(Color("Purple050").opacity(0.6))
//    } //: Body
//    
//}
//
//
//
//struct SaleDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        SaleDetailView(sale: SaleEntity.todaySale1)
//
//    }
//}
