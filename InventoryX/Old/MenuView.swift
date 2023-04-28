//
//
//import SwiftUI
//
//struct MenuView: View {
//    @Binding var displayState: DisplayStates
//    
//    @State var isShowingMenu: Bool = false
//    
//    var body: some View {
//        GeometryReader { geo in
//            HStack {
//                VStack(spacing: 15) {
//                    HStack {
//                        Text("Menu")
//                            .padding()
//                            .font(.system(size: 36, weight: .semibold, design: .rounded))
//                            .frame(maxWidth: .infinity, maxHeight: 50, alignment: .leading)
//                        
//                        Button(action: {
//                            withAnimation {
//                                self.isShowingMenu.toggle()
//                            }
//                        }) {
//                            Image(systemName: self.isShowingMenu ? "chevron.right" : "line.horizontal.3")
//                                .resizable()
//                                .scaledToFit()
//                                .font(.system(size: 24, weight: .medium))
//                                .frame(width: 25, height: self.isShowingMenu ? 20 : 40)
//                        }
//                        .frame(width: 30, height: 30, alignment: .trailing)
//                        .padding(.vertical, 5)
//                        .padding(.horizontal, 15)
//                        .background(primaryColor)
//                        .cornerRadius(9)
//                        .offset(x: self.isShowingMenu ? 0 : 50, y: 0)
//                        
//                    } //: HStack
//                    .padding(.top, 25)
//                    .foregroundColor(Color.white)
//                    
//                    Group {
//                        Button(action: {
//                            self.changeStateTo(.makeASale)
//                        }) {
//                            Text("Make A Sale")
//                        }
//                        .modifier(MenuButtonModifier())
//                        
//                        Divider().background(Color.white)
//                    }
//                    
//                    Group {
//                        Button(action: {
//                            self.changeStateTo(.addInventory)
//                        }) {
//                            Text("Add Inventory")
//                        }
//                        .modifier(MenuButtonModifier())
//                        
//                        Divider().background(Color.white)
//                    }
//                    
//                    Group {
//                        Button(action: {
//                            self.changeStateTo(.inventoryList)
//                        }) {
//                            Text("Inventory List")
//                        }
//                        .modifier(MenuButtonModifier())
//                        
//                        Divider().background(Color.white)
//                    }
//                    
//                    Group {
//                        Button(action: {
//                            self.changeStateTo(.salesHistory)
//                        }) {
//                            Text("Sales History")
//                        }
//                        .modifier(MenuButtonModifier())
//                        
//                        Divider().background(Color.white)
//                    }
//                    
//                    Group {
//                        Button(action: {
//                            self.changeStateTo(.inventoryStatus)
//                        }) {
//                            Text("Inventory Status")
//                        }
//                        .modifier(MenuButtonModifier())
//                        
//                        Divider().background(Color.white)
//                    }
//                    
//                    Spacer()
//                    
//                } //: VStack - Menu View
//                .frame(width: 350)
//                .background(primaryColor)
//                .edgesIgnoringSafeArea(.all)
//                .padding(.bottom, geo.safeAreaInsets.bottom)
//                .padding(.top, geo.safeAreaInsets.top)
//                
//                Spacer(minLength: 0)
//            } //: HStack - MenuView
//            .offset(x: self.isShowingMenu ? 0: -350, y: 0)
//            .background(
//                Color.black.opacity(self.isShowingMenu ? 0.28 : 0)
//                    .edgesIgnoringSafeArea(.all)
//                    .onTapGesture {withAnimation { self.isShowingMenu = false }})
//            .edgesIgnoringSafeArea(.all)
//        } //: Geometry Reader
//    }
//    
//    func changeStateTo(_ newState: DisplayStates) {
//        self.displayState = newState
//        withAnimation { self.isShowingMenu = false }
//    }
//}
