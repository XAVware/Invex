

import SwiftUI
import RealmSwift


class CartViewModel: ObservableObject {
    @Published var uniqueItems: [CartItem] = []
    
    var cartSubtotal: Double {
        var tempTotal: Double = 0
        for item in uniqueItems {
            tempTotal += item.retailPrice * Double(item.qtyInCart)
        }
        return tempTotal
    }

    func addItem(_ item: InventoryItemEntity) {
        var newQty: Int = 1
                
        if let existingItem = uniqueItems.first(where: { $0.id == item._id }) {
            guard let index = uniqueItems.firstIndex(where: { $0.id == item._id }) else { return }
            newQty = existingItem.qtyInCart + 1
            let tempCartItem = CartItem(id: item._id, name: item.name, retailPrice: item.retailPrice, qtyInCart: newQty)
            uniqueItems[index] = tempCartItem
        } else {
            let tempCartItem = CartItem(id: item._id, name: item.name, retailPrice: item.retailPrice, qtyInCart: newQty)
            uniqueItems.append(tempCartItem)
        }
        
    }
}

struct CartItem {
    let id: ObjectId
    let name: String
    let retailPrice: Double
    let qtyInCart: Int
    
    init(id: ObjectId, name: String, retailPrice: Double, qtyInCart: Int) {
        self.id = id
        self.name = name
        self.retailPrice = retailPrice
        self.qtyInCart = qtyInCart
    }
}

struct CartView: View {
    @EnvironmentObject var vm: CartViewModel
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Image(systemName: "cart")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
                    .foregroundColor(lightTextColor)
                    .fontWeight(.semibold)
            }
            
            ScrollView {
                VStack {
                    ForEach(vm.uniqueItems, id: \.id) { item in
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text(item.name)
                                    .modifier(TextMod(.title2, .semibold, .white))
                                
                                Spacer()
                                
                                Image(systemName: "trash")
                                    .foregroundColor(.white)
                            } //: HStack
                            
                            HStack {
                                Text(item.retailPrice.formatToCurrencyString())
                                    .modifier(TextMod(.body, .semibold, .white))
                                
                                Text("x")
                                    .modifier(TextMod(.callout, .regular, .white))
                                
                                Text("\(item.qtyInCart)")
                                    .modifier(TextMod(.body, .semibold, .white))
                            } //: HStack
                        } //: VStack
                        .padding(.vertical, 8)
                        .background(.clear)
                        .frame(maxWidth: 350, alignment: .leading)
                        
                        Divider().background(.white)
                    } //: For Each
                } //: VStack
                .frame(maxHeight: .infinity)
            } //: ScrollView
            
            Divider().background(.white)
            
            HStack {
                Text("Subtotal:")
                    .modifier(TextMod(.title3, .semibold, lightTextColor))
                
                Spacer()
                
                Text(vm.cartSubtotal.formatToCurrencyString())
                    .modifier(TextMod(.title2, .semibold, lightTextColor))
            } //: HStack
            .padding(.vertical, 8)
            .frame(maxWidth: 350)
            
            Button {
                //
            } label: {
                Text("Check Out")
                    .frame(maxWidth: .infinity)
            }
            .modifier(RoundedButtonMod())
            
        } //: VStack
        .padding(.horizontal)
        .background(Color(XSS.S.color20))
        .frame(maxWidth: 350)
//        .onAppear {
//            for item in CategoryEntity.foodCategory.items {
//                vm.addItem(item)
//            }
//        }
    } //: Body
    
}

struct CartView_Previews: PreviewProvider {
    
    static var previews: some View {
        CartView()
            .modifier(PreviewMod())
            .environmentObject(CartViewModel())
    }
}
