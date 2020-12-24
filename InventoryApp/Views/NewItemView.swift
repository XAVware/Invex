//
//  NewItemView.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/24/20.
//

import SwiftUI
import RealmSwift

struct NewItemView: View {
    @State var closingAction: () -> Void
    @State var newItemName: String          = ""
    @State var itemSubtype: String          = ""
    @State var concessionTypeID: Int        = 0
    var concessionTypes: [String]           = ["Food / Snack", "Beverage", "Frozen"]
    @State var isIncludingSubtype: Bool     = false
    
    @State var price: Double                = 1.00
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation { self.closingAction() }
                }
            
            VStack(spacing: 20) {
                HStack {
                    Button(action: {
                        self.closingAction()
                    }) {
                        Text(" X ")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                            .foregroundColor(Color(hex: "365cc4"))
                    }
                    .frame(width: 80, height: 60)
                    
                    Text("New Item")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(hex: "365cc4"))
                    
                    
                    Spacer()
                    .frame(width: 80)
                } //HStack: -Top Bar
                .frame(height: 60)
                
                TextField("Item Name:", text: $newItemName)
                    .padding(10)
                    .background(Color(UIColor.tertiarySystemFill))
                    .cornerRadius(9)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                
                if self.isIncludingSubtype {
                    TextField("Subtype:", text: $itemSubtype)
                        .padding(10)
                        .background(Color(UIColor.tertiarySystemFill))
                        .cornerRadius(9)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .frame(maxWidth: 450)
                }

                Button(action: {
                    withAnimation { self.isIncludingSubtype.toggle() }
                }) {
                    Text(self.isIncludingSubtype ? "- Remove Subtype" : "+ Include Subtype")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(hex: "365cc4"))
                        .opacity(0.8)
                }
                
                
                
                Picker(selection: $concessionTypeID, label: Text("")) {
                    ForEach(0 ..< concessionTypes.count) { index in
                        Text(self.concessionTypes[index]).foregroundColor(.black).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 400)
                
                Text("Retail Price: $\(String(format: "%.2f", self.price))")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(hex: "365cc4"))
                
                Slider(value: $price, in: 0.00 ... 5.00, step: 0.25)
                    .frame(width: 400)
                
                SaveItemButton(action: {
                    self.newItemName = self.newItemName.trimmingCharacters(in: .whitespacesAndNewlines)

                    let newItem = Item()
                    newItem.name = self.newItemName
                    newItem.type = self.concessionTypes[self.concessionTypeID]
                    newItem.retailPrice = String(format: "%.2f", self.price)

                    let config = Realm.Configuration(schemaVersion: 1)
                    
                    let predicate = NSPredicate(format: "name CONTAINS %@", self.newItemName)
                    do {
                        let realm = try Realm(configuration: config)
                        let result = realm.objects(Item.self).filter(predicate)
                        guard result.isEmpty else {
                            print("Item with name \(self.newItemName) already exists -- Returning")
                            return
                        }
                        try realm.write ({
                            realm.add(newItem)
                        })
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                    self.closingAction()
                })
                .padding()
                
                Spacer()
                
            }
            .padding()
            .background(Color.white)
            .cornerRadius(9)
            .frame(width: 600, height: 500, alignment: .center)
        }
    }
}

//struct NewItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewItemView(closingAction: {
//            //
//        })
//            .previewLayout(.fixed(width: 600, height: 500))
//    }
//}
