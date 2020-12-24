//
//  ItemDetailView.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/24/20.
//

import SwiftUI
import RealmSwift

struct ItemDetailView: View {
    @Binding var item: Item
    
    var body: some View {
        
            VStack(spacing: 20) {
                HStack {
                    Button(action: {
    //                    self.selectedItemType = typeString
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 10, height: 15)
                                .font(.system(size: 18, weight: .light, design: .rounded))
                                .foregroundColor(Color(hex: "365cc4"))
                            Text("Back")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.system(size: 18, weight: .light, design: .rounded))
                                .foregroundColor(Color(hex: "365cc4"))
                        }
                    }
                    .frame(width: 60)
                    
                    
                    Text("\(item.name)")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(hex: "365cc4"))
                    
                    Spacer().frame(width: 60)
                } //: HStack - Top Bar
                
                Divider().accentColor(.white)
                
                HStack {
                    Text("Quantity:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 18, weight: .light, design: .rounded))
                        .foregroundColor(Color(hex: "365cc4"))
                        .frame(width: 80)
                    Text("\(item.onHandQty)")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(hex: "365cc4"))
                    
                    Button(action: {
    //                    self.selectedItemType = typeString
                    }) {
                        Text("Adjust")
                            .underline()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.system(size: 14, weight: .light, design: .rounded))
                            .foregroundColor(Color(hex: "365cc4"))
                    }
                    .frame(width: 80)
                } //: HStack
                
                Divider()
                
                HStack {
                    Text("Price:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 18, weight: .light, design: .rounded))
                        .foregroundColor(Color(hex: "365cc4"))
                        .frame(width: 80)
                    Text("$ \(item.retailPrice)")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(hex: "365cc4"))
                    
                    Button(action: {
    //                    self.selectedItemType = typeString
                    }) {
                        Text("Change")
                            .underline()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.system(size: 14, weight: .light, design: .rounded))
                            .foregroundColor(Color(hex: "365cc4"))
                    }
                    .frame(width: 80)
                } //: HStack
                
                Divider()
                
                Button(action: {
    //                    self.selectedItemType = typeString
                }) {
                    Text("Delete Item")
                        .underline()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(Color.red)
                }
                .frame(width: 80)
                
                Spacer()
            } //: VStack
            .padding()
            .background(Color.white)
            .frame(width: 500)
            
        }
        
    
    
    

}

//struct ItemDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemDetailView(item: Item()).previewLayout(.fixed(width: 350, height: 768))
//    }
//}
