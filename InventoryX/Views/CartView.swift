

import SwiftUI
import RealmSwift


@MainActor class CartViewModel: ObservableObject {
    //Original
//    @Published var cartItems: [CartItem]        = []
    @Published var cartTotalString: String      = "$ 0.00"
//    @Published var isEditable: Bool             = true
//    @Published var isConfirmation: Bool         = false
    
    //New
    @Published var cartItems: [CartItem] = []
    
    func finishSale() {
        guard !cartItems.isEmpty else {
            print("There are no items in the cart -- Returning")
            return
        }
        
//        saveSale()
//        saveOnHandQuantities()
        resetCart()
    }
    
    
    func addItem(_ item: InventoryItemEntity) {
        
        var tempCartItem = CartItem(id: item._id, name: item.name, retailPrice: item.retailPrice)
        cartItems.append(tempCartItem)
        
        var tempTotal: Double = 0
        for item in cartItems {
            tempTotal += item.retailPrice
        }
        cartTotalString = "$ \(String(format: "%.2f", tempTotal))"
        print(cartTotalString)
//        updateTotal()
        
    }
    
    func resetCart() {
        cartItems = []
        cartTotalString = "$ 0.00"
//        withAnimation {
//            isEditable = true
//            isConfirmation = false
//        }
    }
    
//    func saveSale() {
//        let sale = Sale()
//        sale.timestamp = Date()
//        var tempTotal: Double = 0.00
//
//        for item in cartItems {
//            let saleItem = SaleItem()
//            saleItem.name = item.name
//            saleItem.subtype = item.subtype
//            saleItem.price = item.price
//            saleItem.qtyToPurchase = item.qtyToPurchase
//            tempTotal += (saleItem.price * Double(saleItem.qtyToPurchase))
//            sale.items.append(saleItem)
//        }
//
//        sale.total = tempTotal
//
//        do {
//            let realm = try Realm()
//            try realm.write {
//                realm.add(sale)
//            }
//        } catch {
//            print("Error saving sale: -- Returning")
//            print(error.localizedDescription)
//            return
//        }
//    }
//
//    func saveOnHandQuantities() {
//        for cartItem in cartItems {
//            let predicate = NSPredicate(format: "name == %@", cartItem.name)
//            do {
//                let realm = try Realm()
//                let result = realm.objects(InventoryItemEntity.self).filter(predicate)
//                for item in result {
//                    try realm.write {
//                        item.onHandQty -= cartItem.qtyToPurchase
//                        realm.add(item)
//                    }
//
//                }
//            } catch {
//                print(error.localizedDescription)
//                return
//            }
//        }
//    }
//
    
//    }
    
    
    
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
//    let
    
    

}

//class CartItem: ObservableObject {
//    var id = UUID()
//    @Published var name: String         = ""
//    @Published var qtyToPurchase: Int   = 1
//    @Published var subtype: String      = ""
//    @Published var price: Double        = 0.00
//
//    var subtotal: Double {
//        return Double(self.qtyToPurchase) * self.price
//    }
//
//    var subtotalString: String {
//        let tempSubtotalString: String = String(format: "%.2f", subtotal)
//        return "$ \(tempSubtotalString)"
//    }
//
//    func increaseQtyInCart() {
//        if self.qtyToPurchase < 24 {
//            self.qtyToPurchase += 1
//        }
//    }
//
//    func decreaseQtyInCart() {
//        if self.qtyToPurchase != 0 {
//            self.qtyToPurchase -= 1
//        }
//    }
//
//}



struct CartView: View {
    @ObservedObject var vm: CartViewModel = CartViewModel()
    @State var cartItems: [InventoryItemEntity] = []
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack {
                Text("Cart")
                    .modifier(TextMod(.title3, .semibold, .black))
                    .frame(maxWidth: .infinity)
                
                
                VStack {
                    ForEach(vm.cartItems, id: \.id) { item in
                        Text(item.name)
                            .modifier(TextMod(.title3, .semibold, .white))
                            .frame(maxWidth: .infinity)
                        
                    }
                } //: VStack
//                List {
//                    ForEach(vm.cartItems) { item in
//                        Text(item.name)
//                            .modifier(TextMod(.title, .regular, .black))
//                            .frame(maxWidth: .infinity)
//                    }
//                    HStack {
                        
                        
//                        Text(String(format: "%.2f", item.retailPrice))
//                            .modifier(TextMod(.callout, .regular, .black))
//                            .frame(maxWidth: .infinity)
//                    } //: HStack
//                } //: List
//                .frame(maxHeight: .infinity)
//                .onReceive(vm.cartItems) { newValue in
//                    self.cartItems = newValue
//                }
                
                Button {
                    //
                } label: {
                    Text("Check Out")
                        .modifier(TextMod(.title3, .semibold, .black))
                        .frame(maxWidth: .infinity)
                }
                
            } //: VStack
//            .edgesIgnoringSafeArea(.trailing)
            .background(.clear)
            
        } //:  HStack
    } //: Body
    
//    var body: some View {
//        GeometryReader { geometry in
//            HStack {
//                Spacer(minLength: 0)
//                VStack(spacing: 16) {
//                    switch self.cart.isConfirmation {
//                    case false:
//                        activeReceiptView
//                    case true:
//                        confirmationView
//                    }
//                } //: VStack
//                .foregroundColor(.white)
//                .frame(width: self.cart.isConfirmation ? geometry.size.width : geometry.size.width * 0.40, height: geometry.size.height)
//                .background(
//                    LinearGradient(gradient: Gradient(colors: [Color("CartBackgroundDark"), Color("CartBackgroundLight")]), startPoint: .topLeading, endPoint: .bottomTrailing)
//                        .cornerRadius(self.cart.isConfirmation ? 0 : 30, corners: [.topLeft, .bottomLeft])
//                        .edgesIgnoringSafeArea(.all)
//                        .shadow(color: .black, radius: 10, x: 0, y: 0)
//                )
//                .animation(.linear(duration: 0.5), value: true)
//                .transition(.asymmetric(insertion: .opacity, removal: .opacity))
//                .overlay(
//                    Button(action: {
//                        withAnimation {
//                            self.cart.isConfirmation = false
//                        }
//                    }) {
//                        HStack(spacing: 3) {
//                            Image(systemName: "chevron.left")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 15, height: 20, alignment: .center)
//
//                            Text("Go Back")
//                        }
//
//                    }
//                    .foregroundColor(.white)
//                    .font(.system(size: 18, weight: .semibold, design: .rounded))
//                    .frame(width: 100)
//                    .padding()
//                    .opacity(self.cart.isConfirmation ? 1 : 0)
//                    , alignment: .topLeading)
//            }
//
//        }
//    } //: Body
//
//    private var activeReceiptView: some View {
//        VStack(spacing: 16) {
//            Text("Cart")
//                .font(.title3)
//
//            VStack(spacing: 0) {
//                HStack(spacing: 0) {
//                    Text("Item:")
//                        .frame(maxWidth: .infinity, alignment: .leading)
//
//                    Text("Qty:")
//                        .frame(maxWidth: .infinity)
//
//                    Text("Price:")
//                        .frame(maxWidth: .infinity, alignment: .trailing)
//                } //: HStack - Column Titles
//                .modifier(DetailTextModifier())
//
//                Divider().background(Color.white).padding(.horizontal)
//
//                Spacer().frame(height: 10)
//
//                //MARK: - Cart Items List
//                List {
//                    ForEach(cart.cartItems, id: \.id) { cartItem in
////                        CartItemView(cart: self.cart, cartItem: cartItem)
//                        HStack {
//                            LazyVStack {
//                                Text(cartItem.name)
//                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//
//                                if cartItem.name != "" {
//                                    Text(self.cartItem.subtype)
//                                        .font(.system(size: 12, weight: .semibold, design: .rounded))
//                                        .frame(maxWidth: .infinity, alignment: .leading)
//                                }
//                            }
//
//                            HStack(spacing: 0) {
//
//                                Button(action: {
//                                    cartItem.decreaseQtyInCart()
//                //                    self.cart.updateTotal()
//                                }) {
//                                    Image(systemName: "minus.circle")
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(width: 20, height: 20)
//                                }
//                                .buttonStyle(PlainButtonStyle())
//                                .opacity(self.cart.isConfirmation ? 0 : 1)
//
//                                Text("\(self.cartItem.qtyToPurchase)")
//                                    .padding()
//                                    .frame(width: 60, height: 40, alignment: .center)
//                                    .font(.system(size: 18, weight: .bold, design: .rounded))
//
//                                Button(action: {
//                                    self.cartItem.increaseQtyInCart()
//                //                    self.cart.updateTotal()
//                                }) {
//                                    Image(systemName: "plus.circle.fill")
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(width: 20, height: 20)
//                                }
//                                .buttonStyle(PlainButtonStyle())
//                                .opacity(self.cart.isConfirmation ? 0 : 1)
//
//                            } //: HStack - Stepper
//                            .frame(maxWidth: .infinity)
//
//                            Text(self.cartItem.subtotalString)
//                                .font(.system(size: 18, weight: .semibold, design: .rounded))
//                                .frame(maxWidth: .infinity, alignment: .trailing)
//
//                        } //: HStack
//                        .frame(height: cartItem.subtype == "" ? 40 : 50)
//                        .foregroundColor(Color.white)
//                    }
//                    .onDelete(perform: { indexSet in
////                        self.cart.removeItem(atOffsets: indexSet)
//                    })
//                    .listRowBackground(Color.clear)
//                } //: ScrollView - Cart Items
//
//                Divider().background(Color.white).padding(.horizontal)
//
//                HStack {
//                    Text("Total: ")
//                        .frame(maxWidth: .infinity, alignment: .leading)
//
//                    Text(self.cart.cartTotalString)
//                        .frame(width: 150, alignment: .trailing)
//                } //: HStack - Cart Total
//                .padding()
//                .font(.system(size: 24, weight: .semibold, design: .rounded))
//                .frame(height: 60)
//
//                Button(action: {
//                    var currentIndex = 0
//                    for cartItem in self.cart.cartItems {
//                        if cartItem.qtyToPurchase == 0 {
//                            self.cart.cartItems.remove(at: currentIndex)
//                        }
//                        currentIndex += 1
//                    }
//
//                    guard !self.cart.cartItems.isEmpty else { return }
//
//                    withAnimation { self.cart.isConfirmation = true }
//
//                }) {
//                    Text("Checkout")
//                } //: Button - Checkout
//                .font(.system(size: 24, weight: .semibold, design: .rounded))
//                .frame(maxWidth: 500, minHeight: 60)
//                .background(Color("GreenBackground"))
//                .cornerRadius(30, corners: self.cart.isConfirmation ? [.allCorners] : [.bottomLeft])
//            } //: VStack
//            .frame(maxWidth: 500)
//        } //: VStack
//    } //: Active Receipt View
//
//    private var confirmationView: some View {
//        VStack() {
//            Text("Checkout")
//                .font(.title3)
//
//            Text("Amount Due:  \(self.cart.cartTotalString)")
//                .padding(.vertical)
//                .font(.system(size: 36, weight: .semibold, design: .rounded))
//                .frame(height: 40)
//
//            Spacer().frame(height: 30)
//
//            HStack(spacing: 0) {
//                Text("Item:")
//                    .frame(maxWidth: .infinity, alignment: .leading)
//
//                Text("Qty:")
//                    .frame(maxWidth: .infinity)
//
//                Text("Price:")
//                    .frame(maxWidth: .infinity, alignment: .trailing)
//            } //: HStack - Column Titles
//            .modifier(DetailTextModifier())
//
//            Divider().background(Color.white).padding(.horizontal)
//
//            Spacer().frame(height: 10)
//
//            ScrollView {
//                ForEach(self.cart.cartItems, id: \.id) { cartItem in
//                    HStack {
//                        LazyVStack {
//                            Text(cartItem.name)
//                                .frame(maxWidth: .infinity, alignment: .leading)
//
//                            if cartItem.name != "" {
//                                Text(cartItem.subtype)
//                                    .font(.system(size: 12, weight: .semibold, design: .rounded))
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//                            }
//                        }
//                        Text("\(cartItem.qtyToPurchase)")
//                            .frame(maxWidth: .infinity, maxHeight: 40, alignment: .center)
//
//                        Text(cartItem.subtotalString)
//                            .frame(maxWidth: .infinity, alignment: .trailing)
//                    } //: HStack
//                    .modifier(DetailTextModifier())
//                    .frame(height:50)
//                } //: ForEach
//            } //: ScrollView - Cart Items
//
//            Divider().background(Color.white).padding(.horizontal)
//
//            Button(action: {
//                self.cart.finishSale()
//            }) {
//                Text("Confirm Sale")
//            } //: Button - Checkout
//            .font(.system(size: 24, weight: .semibold, design: .rounded))
//            .frame(maxWidth: 500, minHeight: 60)
//            .background(Color("GreenBackground"))
//            .cornerRadius(30, corners: self.cart.isConfirmation ? [.allCorners] : [.bottomLeft])
//
//            Spacer().frame(height: 30)
//        }
//        .frame(maxWidth: 500)
//    } //: Confirmation View
}


class SaleItem: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var subtype: String = ""
    @objc dynamic var qtyToPurchase: Int = 0
    @objc dynamic var price: Double = 0.00
}
