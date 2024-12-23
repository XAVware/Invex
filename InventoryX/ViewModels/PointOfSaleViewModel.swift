
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
    
    // TODO: Maybe, Only call this when initialized. Then increment stored property.
//    func calcNextSaleNumber() -> Int {
//        var count: Int = 0
//        count =  RealmActor().getSalesCount()
//        return count + 1
//    }
    
//    func finalizeSale() async throws {
//        // Update the on-hand quantity for each unique item in the cart
////        for index in 0...uniqueItems.count - 1 {
////            let tempItem = uniqueItems[index]
////            let cartQty = cartItems.filter { $0._id == tempItem._id }.count
////            try await RealmActor().adjustStock(for: tempItem, by: cartQty)
////        }
//        
//        // TODO: Improve this...
//        for item in saleItems {
//            try await RealmActor().sellItem(withId: item.id, by: item.qtyInCart)
//        }
//                
//        /// Convert ItemEntities to SaleItemEntities so they can be used in the sale, without
//        /// risking losing an item record on delete.
//        let saleItems = cartItems.map( { SaleItemEntity(item: $0) } )
//        try await RealmActor().saveSale(items: saleItems, total: self.total)
//        cartItems.removeAll()
//        self.saleItems.removeAll()
//    }
    
    
}
