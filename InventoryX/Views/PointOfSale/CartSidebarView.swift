////
////  CartView.swift
////  InventoryX
////
////  Created by Ryan Smetana on 4/9/24.
////
//
//import SwiftUI
//import RealmSwift
//
//struct CartSidebarView: View {
//    @StateObject var vm: PointOfSaleViewModel
//    @State var ignoresTopBar: Bool
//    @State var showCartAlert: Bool = false
//
//    init(vm: PointOfSaleViewModel, ignoresTopBar: Bool) {
//        self._vm = StateObject(wrappedValue: vm)
//        self.ignoresTopBar = ignoresTopBar
//    }
//
//    func continueTapped() {
//        if vm.cartItems.isEmpty {
//            showCartAlert.toggle()
//        } else {
//            LSXService.shared.update(newDisplay: .confirmSale(vm.cartItems))
//        }
//    }
//
//    var body: some View {
//        VStack(alignment: .center, spacing: 0) {
//            Text("Cart")
//            CartItemListView(vm: vm, isEditable: true)
//
//            VStack(alignment: .leading, spacing: 16) {
//                VStack(spacing: 4) {
//
//                    HStack {
//                        Text("Subtotal:")
//                        Spacer()
//                        Text("\(vm.cartSubtotal.formatAsCurrencyString())")
//                    } //: HStack
//
//                    HStack {
//                        Text("Tax:")
//                        Spacer()
//                        Text("\(vm.taxAmount.formatAsCurrencyString())")
//                    } //: HStack
//
//                } //: VStack
//                .font(.subheadline)
//                .padding(8)
//
//                Button(action: continueTapped) {
//                    HStack {
//                        Text("Checkout")
//                            .frame(maxWidth: .infinity)
//                        Text(vm.total.formatAsCurrencyString())
//                    }
//                    .font(.subheadline)
//                    .fontWeight(.semibold)
//                    .fontDesign(.rounded)
//                }
//                .buttonStyle(ThemeButtonStyle())
//
//            } //: VStack
//
//        } //: VStack
//        .padding()
//        //                .frame(maxHeight: geo.size.height * 0.6)
//        .alert("Your cart is empty.", isPresented: $showCartAlert) {
//            Button("Okay", role: .cancel) { }
//        }
//        //TODO: Company data doesn't need to be fetched every time this appears. Just save it in POS VM
//        .onAppear {
//            vm.fetchCompany()
//        }
//        //            } //: ZStack
//        //            .padding(.top, geo.safeAreaInsets.top)
//        //            .padding(.top)
//        //            .padding(.top)
//        //                    .padding()
//        //        }
//    } //: Body
//
//}
//
////#Preview {
////    HStack {
////        CartSidebarView(vm: PointOfSaleViewModel(), ignoresTopBar: false)
////            .environment(\.realm, DepartmentEntity.previewRealm)
////            .frame(maxWidth: 360, alignment: .leading)
////
////        Spacer()
////    }
////}
