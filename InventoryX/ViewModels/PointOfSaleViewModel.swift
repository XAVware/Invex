
import SwiftUI
import RealmSwift


@MainActor class PointOfSaleViewModel: ObservableObject {
    let id = UUID()
    @Published var companyName: String = ""
    @Published var taxRate: Double = 0.0
    @Published var cartSubtotal: Double = 0.0
    var taxAmount: Double { cartSubtotal * taxRate / 100 }
    var total: Double { cartSubtotal + taxAmount }
    
    @Published var cartItems: [CartItem] = []
    @Published var showCartAlert: Bool = false
    
    func checkoutTapped(onSuccess: (() -> Void)?) {
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
        cartSubtotal += item.retailPrice * Double(qty)
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

    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    func clearCart() {
        self.cartItems.removeAll()
        self.cartSubtotal = 0.0
    }
}
