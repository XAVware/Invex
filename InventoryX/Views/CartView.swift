

import SwiftUI
import RealmSwift


@MainActor class CartViewModel: ObservableObject {
    @Published var cartTotalString: String = "$ 0.00"
    
    @Published var cartItems: [CartItem] = []
    
    func addItem(_ item: InventoryItemEntity) {

        var tempCartItem = CartItem(id: item._id, name: item.name, retailPrice: item.retailPrice)
        cartItems.append(tempCartItem)
        
        var tempTotal: Double = 0
        for item in cartItems {
            tempTotal += item.retailPrice
        }
        cartTotalString = "$ \(String(format: "%.2f", tempTotal))"
    }
    
    func getQuantityInCart(for itemId: ObjectId) -> Int {
        let filteredArr = cartItems.filter({ cartItem in
            cartItem.id == itemId
        })
        
        return filteredArr.count
    }
    
    func getItemName(for itemId: ObjectId) -> String {
        let filteredArr = cartItems.filter({ cartItem in
            cartItem.id == itemId
        })
        
        return filteredArr.first?.name ?? "Error"
    }

    var uniqueItemIds: [ObjectId] {
        var uniqueValues: [ObjectId] = []
        cartItems.forEach { item in
            guard !uniqueValues.contains(item.id) else { return }
            uniqueValues.append(item.id)
        }
        return uniqueValues
    }
}

class CartItem: ObservableObject {
    let id: ObjectId
    let name: String
    let retailPrice: Double
    
    init(id: ObjectId, name: String, retailPrice: Double) {
        self.id = id
        self.name = name
        self.retailPrice = retailPrice
    }
}

struct CartView: View {
    @EnvironmentObject var vm: CartViewModel
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack {
                Text("Cart")
                    .modifier(TextMod(.title3, .semibold, lightTextColor))
                    .frame(maxWidth: .infinity)
                
                
                ScrollView {
                    VStack {
                        ForEach(vm.uniqueItemIds, id: \.self) { itemId in
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text(vm.getItemName(for: itemId))
                                        .modifier(TextMod(.title2, .semibold, .white))
                                    
                                    Spacer()
                                    
                                    Image(systemName: "trash")
                                        .foregroundColor(.white)
                                } //: HStack
                                
                                HStack {
                                    Text("x")
                                        .modifier(TextMod(.title3, .semibold, .white))
                                    
                                    Text("\(vm.getQuantityInCart(for: itemId))")
                                        .modifier(TextMod(.title2, .semibold, .white))
                                } //: HStack
                            } //: VStack
                            .padding()
                            .background(.clear)
                            .frame(maxWidth: 350, alignment: .leading)
                            
                            Divider()
                                .background(.white)
                        } //: For Each
                    } //: VStack
                    .frame(maxHeight: .infinity)
                } //: ScrollView
                
                Button {
                    //
                } label: {
                    Text("Check Out")
                        .frame(maxWidth: .infinity)
                }
                .modifier(RoundedButtonMod())
                
            } //: VStack
            .background(Color(XSS.S.color20))
        } //:  HStack
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
