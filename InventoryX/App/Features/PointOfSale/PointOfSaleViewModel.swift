
import SwiftUI
import RealmSwift


@MainActor class PointOfSaleViewModel: ObservableObject {
    @Published var companyName: String = ""
    @Published var taxRate: Double = 0.0
    @Published var cartSubtotal: Double = 0.0
//    var taxAmount: Double { cartSubtotal * taxRate }
//    var total: Double { cartSubtotal + taxAmount }

    var taxAmount: Double {
        (cartSubtotal * taxRate).rounded(to: 2)
    }
    

    var total: Double {
        (cartSubtotal + taxAmount).rounded(to: 2)
    }
    
    @Published var cartItems: [CartItem] = []
    @Published var showCartAlert: Bool = false
    
    init() {
        fetchCompany()
    }
    
    func checkoutTapped(onSuccess: (() -> Void)?) {
        cartItems.removeAll(where: { $0.qtyInCart == 0 })
        guard !cartItems.isEmpty else {
            showCartAlert.toggle()
            return
        }
        
        onSuccess?()
    }
    
    func adjustStock(of item: CartItem, by qty: Int) {
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            cartItems[index].qtyInCart += qty
        } else {
            cartItems.append(item)
        }
        recalculateSubtotal()
    }
    
    func fetchCompany() {
        do {
            guard let company = try RealmActor().fetchCompany() else { return }
            self.companyName = company.name
            self.taxRate = company.taxRate
        } catch {
            debugPrint(error.localizedDescription)
        }
        
    }
    
    func removeItemFromCart(withId id: ObjectId) {
        cartItems.removeAll(where: { $0.id == id })
        recalculateSubtotal()
    }
    
    func recalculateSubtotal() {
        cartSubtotal = cartItems.reduce(0) { $0 + $1.retailPrice * Double($1.qtyInCart) }
    }
    
    func clearCart() {
        self.cartItems.removeAll()
        self.cartSubtotal = 0.0
    }
}
