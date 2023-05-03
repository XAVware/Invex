//
//  AddItemView.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 5/2/23.
//

import SwiftUI
import RealmSwift

struct AddItemView: View {
    
    @State var newItemType: String = "-Select Type-"
    @State var newItemPrice: Double = 1.00
    @State var quantityPurchased: Int = 24
    @State var typeExpanded: Bool = false
    @State var priceExpanded: Bool = false
    @State var quantityExpanded: Bool = false
    @State var errorMessage: String = ""
    @State var savedSuccessfully: Bool = false
    
    
    //New
    @Environment(\.dismiss) var dismiss
    @ObservedResults(CategoryEntity.self) var categories
    @State var itemName: String = ""
    @State var quantity: String = ""
    @State var retailPrice: String = ""
    @State var unitCost: String = ""
    @State var category: CategoryEntity?
    
    
    func saveItem() {
        guard itemName.isNotEmpty, quantity.isNotEmpty, retailPrice.isNotEmpty else { return }
        
        let newItem = InventoryItemEntity(name: itemName, retailPrice: Double(retailPrice) ?? 1.0, avgCostPer: Double(unitCost) ?? 0.5, onHandQty: Int(quantity) ?? 10)
        
        if let category = category {
            category.items.append(newItem)
        }
    }
    
    var body: some View {
        ZStack {
            Color(XSS.S.color90)
            VStack(spacing: 16) {
                Text("New Item")
                    .modifier(TextMod(.largeTitle, .semibold))
                
                Spacer()
                
                AnimatedTextField(boundTo: $itemName, placeholder: "Item Name")
                
                HStack {
                    Text("Category:")
                    Spacer()
                    Picker(selection: $category) {
                        ForEach(categories) { category in
                            Text(category.name)
                        }
                    } label: {
                        Text("Category")
                    }
                    .tint(darkTextColor)
                }
                
                
                AnimatedTextField(boundTo: $quantity, placeholder: "Qty. On-Hand")
                
                AnimatedTextField(boundTo: $retailPrice, placeholder: "Retail Price")
                
                AnimatedTextField(boundTo: $unitCost, placeholder: "Unit Cost")
                
                Spacer()
                
                Button {
                    saveItem()
                } label: {
                    Text("Save and Add Another")
                }
                .modifier(RoundedButtonMod())
                
                Button {
                    //
                } label: {
                    Text("Save and Finish")
                }
                .modifier(RoundedButtonMod())
                .frame(width: 250)
                
            } //: VStack
            .frame(maxWidth: 400)
            .padding(.bottom)
        } //: ZStack
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            category = categories.first
        }
    } //: Body
    
    private var originalView: some View {
        VStack {
            VStack {
                Text(self.$errorMessage.wrappedValue)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.red)
                
                TextField("Item Name:", text: $itemName)
                    .modifier(TextFieldModifier())
                
            } //: VStack
            .padding(.vertical)
            
            GroupBox {
                DisclosureGroup(isExpanded: self.$typeExpanded) {
                    Divider().padding(.top).padding(.bottom, 2)
                    VStack {
                        ForEach(categoryList, id: \.self) { category in
                            Button(action: {
                                self.newItemType = category.name
                            }) {
                                HStack {
                                    Text(category.name)
                                        .font(.system(size: 18, design: .rounded))
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    Image(systemName: self.newItemType == category.name ? "checkmark.circle.fill" : "circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(primaryColor)
                                } //: HStack
                            } //: Button - Concession Type
                            if category.name != categoryList[categoryList.count - 1].name {
                                Divider()
                            }
                        } //: ForEach
                    } // VStack
                } label: {
                    HStack {
                        Text("Item Type:")
                            .frame(maxWidth:.infinity, alignment: .leading)
                            .font(.callout)
                        
                        Text("\(self.$newItemType.wrappedValue)")
                            .frame(maxWidth:.infinity, alignment: .center)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                        
                        Text(self.typeExpanded ? "Confirm" : "Change")
                            .frame(maxWidth:.infinity, alignment: .trailing)
                            .font(.footnote)
                    } //: HStack
                    .foregroundColor(.black)
                } //: DisclosureGroup
            } //: GroupBox - Item Type
            .onTapGesture { withAnimation { self.typeExpanded.toggle() } }
            
            GroupBox {
                DisclosureGroup(isExpanded: self.$priceExpanded) {
                    Divider().padding(.vertical)
                    Slider(value: $newItemPrice, in: 0.00 ... 5.00, step: 0.25)
                        .frame(width: 400)
                        .padding(.bottom)
                } label: {
                    HStack {
                        Text("Retail Price:")
                            .frame(maxWidth:.infinity, alignment: .leading)
                            .font(.callout)
                        
                        Text("$\(String(format: "%.2f", self.newItemPrice))")
                            .frame(maxWidth:.infinity, alignment: .center)
                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                        
                        Text(self.priceExpanded ? "Confirm" : "Change")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .font(.footnote)
                    } //: HStack
                } //: DisclosureGroup
                .foregroundColor(.black)
                .onTapGesture { withAnimation { self.priceExpanded.toggle() } }
            } //GroupBox - Price
            
            GroupBox {
                DisclosureGroup(isExpanded: self.$quantityExpanded) {
                    VStack {
                        Divider().padding(.vertical)
                        QuantitySelector(selectedQuantity: self.$quantityPurchased, showsCustomToggle: true)
                    }
                } label: {
                    HStack {
                        Text("Quantity Purchased:")
                            .frame(maxWidth:.infinity, alignment: .leading)
                            .font(.callout)
                        
                        Text("\(self.quantityPurchased)")
                            .frame(maxWidth:.infinity, alignment: .center)
                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                        
                        Text(self.quantityExpanded ? "Confirm" : "Change")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .font(.footnote)
                    } //: HStack
                    .onTapGesture { withAnimation { self.quantityExpanded.toggle() } }
                } //: DisclosureGroup
                .foregroundColor(.black)
            } //: GroupBox
            
            SaveItemButton(action: {
                self.typeExpanded = false
                self.priceExpanded = false
                self.quantityExpanded = false
                
                self.errorMessage = ""
                
                guard self.quantityPurchased >= 0 else {
                    self.errorMessage = "Please enter a valid quantity"
                    self.priceExpanded = false
                    self.typeExpanded = false
                    withAnimation { self.quantityExpanded = true }
                    return
                }
                
                //            switch self.viewType {
                //            case .newItem:
                //                guard self.saveNewItem() == .success else {
                //                    return
                //                }
                //            case .restockItem:
                //                guard self.restockItem() == .success else {
                //                    return
                //                }
                //            }
                
                self.savedSuccessfully = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    dismiss()
                }
                
            }) //: Save Button
            .buttonStyle(PlainButtonStyle())
            .padding()
            .overlay(
                ZStack {
                    if self.savedSuccessfully {
                        Color.white.frame(maxWidth: .infinity, maxHeight: .infinity)
                        AnimatedCheckmarkView()
                    }
                }
                
            )
        }
        .onChange(of: self.typeExpanded, perform: { typeIsExpanded in
            if typeIsExpanded {
                self.priceExpanded = false
                self.quantityExpanded = false
            }
        })
        .onChange(of: self.priceExpanded, perform: { priceIsExpanded in
            if priceIsExpanded {
                self.typeExpanded = false
                self.quantityExpanded = false
            }
        })
        .onChange(of: self.quantityExpanded, perform: { quantityIsExpanded in
            if quantityIsExpanded {
                self.typeExpanded = false
                self.priceExpanded = false
            }
        })
    } //: Original View
}


struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView()
            .modifier(PreviewMod())
    }
}
