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
                }
                
            }
            
            MenuView(appManager: self.appManager)
        }
        
        
        
        
        
        
        
        
        
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
    
    func ColorFromRGB(rgb: UInt) -> Color {
        return Color(
            red: Double((rgb & 0xFF0000) >> 16) / 255.0,
            green: Double((rgb & 0x00FF00) >> 8) / 255.0,
            blue: Double(rgb & 0x0000FF) / 255.0
        )
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


extension Color {
    init(hex string: String) {
        var string: String = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if string.hasPrefix("#") {
            _ = string.removeFirst()
        }
        
        // Double the last value if incomplete hex
        if !string.count.isMultiple(of: 2), let last = string.last {
            string.append(last)
        }
        
        // Fix invalid values
        if string.count > 8 {
            string = String(string.prefix(8))
        }
        
        // Scanner creation
        let scanner = Scanner(string: string)
        
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        
        if string.count == 2 {
            let mask = 0xFF
            
            let g = Int(color) & mask
            
            let gray = Double(g) / 255.0
            
            self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: 1)
            
        } else if string.count == 4 {
            let mask = 0x00FF
            
            let g = Int(color >> 8) & mask
            let a = Int(color) & mask
            
            let gray = Double(g) / 255.0
            let alpha = Double(a) / 255.0
            
            self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: alpha)
            
        } else if string.count == 6 {
            let mask = 0x0000FF
            let r = Int(color >> 16) & mask
            let g = Int(color >> 8) & mask
            let b = Int(color) & mask
            
            let red = Double(r) / 255.0
            let green = Double(g) / 255.0
            let blue = Double(b) / 255.0
            
            self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1)
            
        } else if string.count == 8 {
            let mask = 0x000000FF
            let r = Int(color >> 24) & mask
            let g = Int(color >> 16) & mask
            let b = Int(color >> 8) & mask
            let a = Int(color) & mask
            
            let red = Double(r) / 255.0
            let green = Double(g) / 255.0
            let blue = Double(b) / 255.0
            let alpha = Double(a) / 255.0
            
            self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
            
        } else {
            self.init(.sRGB, red: 1, green: 1, blue: 1, opacity: 1)
        }
    }
}
