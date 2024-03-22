////
////  InventoryStatusView.swift
////  InventoryX
////
////  Created by Ryan Smetana on 6/4/23.
////
//
//import SwiftUI
//import RealmSwift
//
//struct InventoryStatusView: View {
//    @EnvironmentObject var navMan: NavigationManager
//    @ObservedResults(DepartmentEntity.self) var categories
//    @ObservedResults(ItemEntity.self) var items
//    
//    func getRestockStatus(for item: ItemEntity) -> Bool {
//        guard let category = item.department.first?.thaw() else { return true }
//        let restockNum = category.restockNumber
//        return item.onHandQty > restockNum ? false : true
//    }
//    
//    var body: some View {
//        VStack {
//            List(items) { item in
//                if getRestockStatus(for: item) {
//                    Text(item.name)
//                }
//            } //: List
//        } //: VStack
//    }
//
//}
//
//struct InventoryStatusView_Previews: PreviewProvider {
//    static var previews: some View {
//        InventoryStatusView()
//            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (4th generation)"))
//            .previewInterfaceOrientation(.landscapeLeft)
//    }
//}
