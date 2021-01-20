//
//  ItemDetailView.swift
//  InventoryV2
//
//  Created by Ryan Smetana on 12/27/20.
//

import SwiftUI
import RealmSwift

struct ItemDetailView: View {
    @Binding var item: Item
    @State var closingAction: () -> Void
    
    @State var isAdjustingQuantity: Bool    = false
    @State var isAdjustingPrice: Bool       = false
    
    @State var newQuantity: Int             = 0
    @State var newPrice: Double             = 1.00
    
    var originalQuantity: Int {
        return item.onHandQty
    }
    
    var originalPrice: String {
        return item.retailPrice
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: {
                    withAnimation {
                        self.closingAction()
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .scaledToFit()
                        .accentColor(Color(hex: "365cc4"))
                        .font(.system(size: 24, weight: .medium))
                }
                .frame(width: 25, height: 20)
                
                
                
                Text("\(item.name)")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(hex: "365cc4"))
                
                Spacer().frame(width: 25)
            }
            
            
            Divider()
            
            HStack {
                Text("Quantity:")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 18, weight: .light, design: .rounded))
                    .foregroundColor(Color(hex: "365cc4"))
                    .frame(width: 80)
                
                if self.isAdjustingQuantity {
                    HStack(spacing: 0) {
                        Button(action: {
                            self.newQuantity -= 1
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                                .accentColor(Color(hex: "365cc4"))
                        }
                        .shadow(radius: 2)
                        
                        Text("\(self.$newQuantity.wrappedValue)")
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .multilineTextAlignment(.center)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .frame(maxWidth: 80)
                            .foregroundColor(Color.black)
                        
                        Button(action: {
                            self.newQuantity += 1
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                                .accentColor(Color(hex: "365cc4"))
                        }
                        .shadow(radius: 2)
                    }//: HStack
                    .frame(maxWidth: .infinity)
                    
                } else {
                    Text("\(item.onHandQty)")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(hex: "365cc4"))
                }
                
                Button(action: {
                    if !self.isAdjustingQuantity {
                        self.newQuantity = self.originalQuantity
                    } else {
                        let predicate = NSPredicate(format: "name CONTAINS %@", self.item.name)
                        let config = Realm.Configuration(schemaVersion: 1)
                        do {
                            let realm = try Realm(configuration: config)
                            let result = realm.objects(Item.self).filter(predicate)
                            for item in result {
                                try realm.write ({
                                    print("Changing Quantity of \(item.name) from \(self.originalQuantity) to \(self.newQuantity)")
                                    item.onHandQty = self.newQuantity
                                    realm.add(item)
                                })
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    self.isAdjustingQuantity.toggle()
                }) {
                    Text(self.isAdjustingQuantity ? "Finish" : "Adjust")
                        .underline()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.system(size: 14, weight: .light, design: .rounded))
                        .foregroundColor(Color(hex: "365cc4"))
                }
                .frame(width: 80)
            } //: HStack
            
            Divider()
            
            VStack {
                HStack {
                    Text("Price:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 18, weight: .light, design: .rounded))
                        .foregroundColor(Color(hex: "365cc4"))
                        .frame(width: 80)
                    
                    Text("$ \(self.isAdjustingPrice ? String(format: "%.2f", self.newPrice) : self.originalPrice)")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(hex: "365cc4"))
                    
                    Button(action: {
                        if !self.isAdjustingPrice {
                            self.newPrice = Double(self.originalPrice)!
                            
                        } else {
                            let predicate = NSPredicate(format: "name CONTAINS %@", self.item.name)
                            let config = Realm.Configuration(schemaVersion: 1)
                            do {
                                let realm = try Realm(configuration: config)
                                let result = realm.objects(Item.self).filter(predicate)
                                for item in result {
                                    try realm.write ({
                                        item.retailPrice = String(format: "%.2f", self.newPrice)
                                        realm.add(item)
                                    })
                                }
                            } catch {
                                print(error.localizedDescription)
                            }
                            
                        }
                        
                        self.isAdjustingPrice.toggle()
                    }) {
                        Text(self.isAdjustingPrice ? "Finish" : "Change")
                            .underline()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.system(size: 14, weight: .light, design: .rounded))
                            .foregroundColor(Color(hex: "365cc4"))
                    }
                    .frame(width: 80)
                } //: HStack
                
                if self.isAdjustingPrice {
                    Slider(value: $newPrice, in: 0.00 ... 5.00, step: 0.25)
                        .frame(width: 300)
                }
            } //: VStack
            
            Divider()
            
            Button(action: {
//                self.deleteAction()
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
        .background(Color.white.edgesIgnoringSafeArea(.all))
        
    }
}
