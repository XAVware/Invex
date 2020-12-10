//
//  ContentView.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/9/20.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    @StateObject var appManager = AppStateManager()
    
    var body: some View {
        
        ZStack {
            VStack(spacing: 0) {
                HeaderView(appManager: self.appManager)
                
                ZStack {
                    
                    
                    //MARK: - Make A Sale Stack
                    HStack(spacing: 0) {
                        
                        VStack(spacing: 0) {
                            
                            HStack(spacing: 0) {
                                //MARK: - Food & Snack Section
                                ZStack {
                                    Color(hex: "dc2430").opacity(0.6)
                                    
                                    VStack(spacing: 0) {
                                        Text("Food & Snacks")
                                            .padding(.vertical, 7)
                                            .foregroundColor(.black)
                                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                                        
                                        Divider()
                                            .background(Color.black)
                                            .padding(.horizontal)
                                        
                                        ScrollView(.vertical, showsIndicators: false) {
                                            ForEach(self.appManager.foodSnackList, id: \.self) { item in
                                                ItemButton(item: item, colorHexString: "b5ac49")
                                            }
                                        }//: ScrollView
                                    } //: VStack
                                } //: ZStack - Food & Snack Section
                                
                                
                                
                                //MARK: - Beverage Section
                                ZStack {
                                    LinearGradient(gradient: Gradient(colors: [Color(hex: "005C97").opacity(0.7), Color(hex: "363795").opacity(0.8)]), startPoint: .bottom, endPoint: .top)
                                    
                                    VStack(spacing: 0) {
                                        Text("Beverages")
                                            .padding(.vertical, 7)
                                            .foregroundColor(.black)
                                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                                        
                                        Divider()
                                            .background(Color.black)
                                            .padding(.horizontal)
                                        
                                        Spacer().frame(height: 10)
                                        
                                        ScrollView(.vertical, showsIndicators: false) {
                                            ForEach(self.appManager.beverageList, id: \.self) { item in
                                                ItemButton(item: item, colorHexString: "1488cc")
                                            }
                                            
                                        } //: ScrollView
                                    } //: VStack
                                } //: ZStack - Beverage Section
                                
                                
                            } //: HStack - Top Sections
                            
                            //MARK: - Frozen Section
                            ZStack {
                                LinearGradient(gradient: Gradient(colors: [Color(hex: "F1F2B5").opacity(0.8), Color(hex: "135058").opacity(0.7)]), startPoint: .top, endPoint: .bottom)
                                
                                VStack(spacing: 0) {
                                    Text("Beverages")
                                        .padding(.vertical, 7)
                                        .foregroundColor(.black)
                                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                                    
                                    Divider()
                                        .background(Color.black)
                                        .padding(.horizontal)
                                    
                                    ScrollView(.vertical, showsIndicators: false) {
                                        ForEach(self.appManager.frozenList, id: \.self) { item in
                                            Button(action: {
                                                
                                            }) {
                                                Text(item.name)
                                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                                    .foregroundColor(.black)
                                            }
                                            .frame(width: 100, height: 50)
                                            .cornerRadius(10)
                                            .background(
                                                Color.blue
                                            )
                                        }
                                    }
                                }
                            } //: ZStack - Frozen Section
                            .frame(height: 250)
                            
                        }
                        
                        //MARK: - Cart Section
                        ZStack {
                            LinearGradient(gradient: Gradient(colors: [Color(hex: "141E30").opacity(0.8), Color(hex: "243B55").opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                
                            
                            VStack(spacing: 0) {
                                Text("Cart")
                                    .padding(.vertical, 7)
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                                
                                Divider()
                                    .background(Color.white)
                                    .padding(.horizontal)
                                
                                Spacer()
                                
                                Divider()
                                    .background(Color.white)
                                    .padding(.horizontal)
                                
                                HStack {
                                    Text("Total: ")
                                        .foregroundColor(.white)
                                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text("$ 0.00")
                                        .foregroundColor(.white)
                                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                                        .frame(width: 150, alignment: .trailing)
                                }
                                .padding()
                                
                                Button(action: {
                                    
                                }) {
                                    Text("Checkout")
                                        .foregroundColor(.black)
                                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                                }
                                .frame(maxWidth: .infinity, minHeight: 60)
                                .background(
                                    Color.green
                                )
                            }
                        } //: ZStack - Cart Section
                        .frame(width: 350)
                        
                    } //: VStack
                    
                    if self.appManager.isShowingAddItem {
                        AddInventoryView(appManager: self.appManager)
                    }
                    
                    
                }
                
            } //: VStack used to keep header above all pages
            
            
            MenuView(appManager: self.appManager) //Menu should always be at top of ZStack
        } //: ZStack
        .onAppear {
            self.appManager.getAllItems()
        }

   
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.fixed(width: 1024, height: 786))
    }
}

class datatype: Object {
    @objc dynamic var name = ""
    @objc dynamic var age = ""
}


