//
//  ContentView.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/9/20.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    
    @State var name = ""
    @State var age = ""
    
    var body: some View {
        
        VStack(spacing: 0) {
            HStack {
                Color.black
            }
            .frame(height: 100)
            
            HStack(spacing: 0) {
                
                VStack(spacing: 0) {
                    
                    HStack(spacing: 0) {
                        Color.red
                        Color.blue
                    }
                    Color(UIColor(.purple))
                }
                Color.gray
                    .frame(width: 500)
            }
            
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.fixed(width: 2048, height: 1536))
    }
}

class datatype: Object {
    @objc dynamic var name = ""
    @objc dynamic var age = ""
}
