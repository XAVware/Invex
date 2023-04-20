

import SwiftUI
import RealmSwift

struct EditItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedItem: InventoryItem
    
    @State var priceExpanded: Bool      = false
    @State var quantityExpanded: Bool   = false
    @State var tempPrice: Double        = 0.0
    @State var tempQuantity: Int        = 0
    @State var savedSuccessfully        = false
    @State var willDelete               = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer(minLength: 40)
                
                Text("Edit Item")
                    .modifier(TitleModifier())
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 20, alignment: .center)
                }
            } //: HStack - Header
            .modifier(HeaderModifier())
            
            ScrollView(.vertical, showsIndicators: false) {
                GroupBox {
                    Text("\(self.selectedItem.name) \(self.selectedItem.subtype == "" ? "" : "- \(self.selectedItem.subtype)")")
                        .frame(maxWidth:.infinity, alignment: .center)
                        .font(.title2)
                        .foregroundColor(.black)
                } //: GroupBox
                
                GroupBox {
                    DisclosureGroup(isExpanded: self.$priceExpanded) {
                        Divider().padding(.vertical)
                        Slider(value: self.$tempPrice, in: 0.00 ... 5.00, step: 0.25)
                            .frame(width: 400)
                            .padding(.bottom)
                    } label: {
                        HStack {
                            Text("Retail Price:")
                                .frame(maxWidth:.infinity, alignment: .leading)
                                .font(.callout)
                            
                            Text("$\(String(format: "%.2f", self.tempPrice))")
                                .frame(maxWidth:.infinity, alignment: .center)
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                            
                            Text(self.priceExpanded ? "Confirm" : "Change")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .font(.footnote)
                        } //: HStack
                    } //: DisclosureGroup
                    .foregroundColor(.black)
                    .onTapGesture { withAnimation { self.priceExpanded.toggle() } }
                    
                } //: GroupBox - Price
                
                GroupBox {
                    DisclosureGroup(isExpanded: self.$quantityExpanded) {
                        VStack {
                            Divider().padding(.vertical)
                            QuantitySelector(selectedQuantity: self.$tempQuantity, showsCustomToggle: false)
                                .padding(.bottom)
                        }
                    } label: {
                        HStack {
                            Text("On Hand Quantity:")
                                .frame(maxWidth:.infinity, alignment: .leading)
                                .font(.callout)
                            
                            Text("\(self.tempQuantity)")
                                .frame(maxWidth:.infinity, alignment: .center)
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                            
                            Text(self.quantityExpanded ? "Confirm" : "Change")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .font(.footnote)
                        } //: HStack
                        .onTapGesture { withAnimation { self.quantityExpanded.toggle() } }
                    } //: DisclosureGroup
                    .foregroundColor(.black)
                } //: GroupBox
            } //: ScrollView
            .frame(maxWidth: 500)
            
            SaveItemButton(action: {
                self.priceExpanded = false
                self.quantityExpanded = false
                
                guard self.saveItem() == .success else { return }
                
                self.savedSuccessfully = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.presentationMode.wrappedValue.dismiss()
                }
                
            }) //: Save Button
            .buttonStyle(PlainButtonStyle())
            .padding()
            
            Button(action: { self.willDelete = true }) {
                Text("Delete Item")
            }
            .foregroundColor(Color.red)
            .padding()
        } //: VStack
        .overlay(
            ZStack {
                if self.willDelete || self.savedSuccessfully {
                    Color.white.frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                if self.willDelete {
                    VStack {
                        Spacer()
                        Text("Are you sure you want to delete this item?")
                            .modifier(TitleModifier())
                        Spacer().frame(height: 40)
                        Button(action: {
                            self.willDelete = false
                        }) {
                            Text("No, Go Back")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        .padding()
                        .frame(width: 400, height: 60)
                        .background(Color("GreenBackground"))
                        .cornerRadius(30)
                        .shadow(color: Color("ShadowColor"), radius: 8, x: 0, y: 4)
                        
                        Button(action: {
                            let realm = try! Realm()
                            try! realm.write {
                                realm.delete(self.selectedItem)
                            }
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Yes, delete item forever")
                        }
                        .foregroundColor(Color.red)
                        .padding()
                        Spacer()
                    }
                }
                
                if self.savedSuccessfully {
                    AnimatedCheckmarkView()
                }
            }
        )
        .onAppear {
            self.tempPrice = selectedItem.retailPrice
            self.tempQuantity = selectedItem.onHandQty
        }
    } //: Body
    
    func saveItem() -> SaveResult {
        let realm = try! Realm()
        let tempItem = self.selectedItem
        do {
            try realm.write ({
                tempItem.retailPrice = self.tempPrice
                tempItem.onHandQty = self.tempQuantity
                realm.add(tempItem)
                
            })
        } catch {
            return .failure
        }
        return .success
    }
}
