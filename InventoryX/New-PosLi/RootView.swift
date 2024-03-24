//
//  RootView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/19/24.
//

import SwiftUI
import RealmSwift
import Combine

class RootViewModel: ObservableObject {
    
    private let service = AuthService.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var companyExists: Bool = false
//    @Published var passHash: String = ""
    
    
    init() {
        configureSubscribers()
    }
    
    func configureSubscribers() {
        service.$exists
            .sink { [weak self] exists in
                self?.companyExists = exists
                print("Exists received: \(exists)")
            }
            .store(in: &cancellables)
        
        
//        service.$passHash
//            .sink { [weak self] hash in
//                self?.passHash = hash
//                print("Hash received: \(hash)")
//            }
//            .store(in: &cancellables)
    }
}

struct RootView: View {
    let uiProperties: LayoutProperties
    @StateObject var vm = RootViewModel()
    @StateObject var posVM = MakeASaleViewModel()
    
    @State var currentDisplay: DisplayState = .makeASale
    @State var menuState: MenuState = .compact
    @State var cartState: CartState = .sidebar
    
    @State var selectedDepartment: DepartmentEntity?
    
    @State var showingOnboarding: Bool = false
    @State var showingLockScreen: Bool = false
    
    var detailWidth: CGFloat {
        var dWidth: CGFloat = 1
        
        switch currentDisplay {
        case .makeASale:
            switch cartState {
            case .hidden:
                dWidth = 0
                
            case .sidebar:
                if menuState == .open {
                    dWidth = uiProperties.width * 0.20
                } else {
                    dWidth = uiProperties.width * 0.25
                }
                
            case .confirming:
                dWidth = uiProperties.width
            }
            
        default:
            dWidth = 0
        }
        return dWidth
    }

        
    var body: some View {
        HStack {
            // SHould make state not
            if uiProperties.horizontalSizeClass == .regular && cartState != .confirming {
                Menu(display: $currentDisplay, menuState: $menuState)
                    .frame(maxWidth: menuState == .open ? uiProperties.width * 0.2 : nil)
            }
            
            HStack {
                // MARK: - CONTENT
                VStack(spacing: 6) {
                    if cartState != .confirming {
                        ToolbarView(menuState: $menuState, cartState: $cartState, display: $currentDisplay)
                            .padding()
                    }
                    
                    switch currentDisplay {
                    case .makeASale:
                        if cartState != .confirming {
                            VStack(spacing: 24) {
                                DepartmentPicker(selectedDepartment: $selectedDepartment, style: .scrolling)
                                
                                ItemTableView(department: $selectedDepartment, style: .grid) { item in
                                    // Add the item to cart. Otherwise select the item so it can be displayed in a add/modify item view.
                                    posVM.itemTapped(item: item)
                                }
                                
                            } //: VStack
                            .padding(.horizontal)
                        } 
                        
                    case .inventoryList:
                            
                            ItemTableView(department: $selectedDepartment, style: .list) { item in
                                // Display item in view/edit item view.
                                // Handle through protocol
                                posVM.itemTapped(item: item)
                            }
                            
                    case .salesHistory:
                        Text("Sales")
                        
                    case .settings:
                        DepartmentsView()
                        
                    default: Divider()
                    }
                    
                } //: VStack
                
                // MARK: - DETAIL
                if detailWidth > 0 {
                    switch currentDisplay {
                    case .makeASale:
                        CartViewNew(cartState: $cartState, menuState: $menuState)
                            .environmentObject(posVM)
                            .padding()
                            .background(Color("Purple050").opacity(0.5))
                            .frame(maxWidth: cartState == .confirming ? .infinity : detailWidth)
                            .frame(maxHeight: .infinity)

                        
                    case .settings:
                        DepartmentsView()
                        
                    default: Divider()
                    }
                    
                
                } else {
                    Divider()
                }
            } //: HStack

        } //: HStack
        .onReceive(vm.$companyExists) { exists in
            showingOnboarding = !exists
        }
        .onChange(of: currentDisplay) { newValue in
            if newValue == .lockScreen {
                showingLockScreen = true
            }
        }
        .fullScreenCover(isPresented: $showingLockScreen) {
            LockScreenView()
        }
        .fullScreenCover(isPresented: $showingOnboarding) {
            OnboardingView()
        }
        
    } //: Body
    
}

#Preview {
    ResponsiveView { props in
        RootView(uiProperties: props)
            .environment(\.realm, DepartmentEntity.previewRealm)
    }
}
