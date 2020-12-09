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
    
    @State var name = ""
    @State var age = ""
    
    var body: some View {
        
        ZStack {
            VStack(spacing: 0) {
                HeaderView(appManager: self.appManager)
                
                ZStack {
                    
                    
                    //MARK: - Make A Sale Stack
                    HStack(spacing: 0) {
                        
                        VStack(spacing: 0) {
                            
                            HStack(spacing: 0) {
                                LinearGradient(gradient: Gradient(colors: [Color(hex: "7b4397").opacity(0.7), Color(hex: "dc2430").opacity(0.8)]), startPoint: .bottom, endPoint: .top)
                                
                                LinearGradient(gradient: Gradient(colors: [Color(hex: "005C97").opacity(0.7), Color(hex: "363795").opacity(0.8)]), startPoint: .bottom, endPoint: .top)
                                
                                
                            }
                            LinearGradient(gradient: Gradient(colors: [Color(hex: "F1F2B5").opacity(0.8), Color(hex: "135058").opacity(0.7)]), startPoint: .top, endPoint: .bottom)
                                .frame(height: 250)
                            
                        }
                        
                        LinearGradient(gradient: Gradient(colors: [Color(hex: "141E30").opacity(0.8), Color(hex: "243B55").opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                            .frame(width: 350)
                    } //: HStack
                    
                    if self.appManager.isShowingAddItem {
                        AddInventoryView(appManager: self.appManager)
                    }
                    
                    
                }
                
            } //: VStack used to keep header above all pages
            
            
            MenuView(appManager: self.appManager) //Menu should always be at top of ZStack
        } //: ZStack
        //        .fullScreenCover(isPresented: self.$appManager.isShowingAddItem, content: {
        //            AddInventoryView(appManager: self.appManager)
        //        })
        
        
        
        
        
        
        
        
        
        //        VStack {
        //            TextField("Name", text: $name).textFieldStyle(RoundedBorderTextFieldStyle())
        //            TextField("Age", text: $age).textFieldStyle(RoundedBorderTextFieldStyle())
        //            Button(action: {
        //                let config = Realm.Configuration(schemaVersion: 1)
        //                do {
        //                    let realm = try Realm(configuration: config)
        //                    let newData = datatype()
        //                    newData.name = self.name
        //                    newData.age = self.age
        //                    try realm.write({
        //                        realm.add(newData)
        //                        print("Success")
        //                    })
        //                } catch {
        //                    print(error.localizedDescription)
        //                }
        //            }) {
        //                Text("Save")
        //            }
        //            Button(action: {
        //
        //                let config = Realm.Configuration(schemaVersion: 1)
        //                do {
        //                    let realm = try Realm(configuration: config)
        //                    let result = realm.objects(datatype.self)
        //                    print(result)
        //                } catch {
        //                    print(error.localizedDescription)
        //                }
        //            }) {
        //                Text("Load")
        //            }
        //        }
        //        .padding()
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


