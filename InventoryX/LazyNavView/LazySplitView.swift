//
//  SplitInSplitView.swift
//  CustomSplitView
//
//  Created by Ryan Smetana on 5/17/24.
//


import SwiftUI
import Combine


enum MenuVisibility {
    case hidden
    case visible
}

enum Layout { case full, column }

// MARK: - Lazy Split Service
// Maybe move towards:
//enum LazySplitColumn { case leftSidebar, supplemental, primaryContent, detail, rightSidebar }

// Does this need to be a main actor?
@MainActor class LazyNavService {
    @Published var mainDisplay: DisplayState
    @Published var path: NavigationPath = .init()
    @Published var detailPath: NavigationPath = .init()
    
    static let shared = LazyNavService()
    
    init() {
        self.mainDisplay = DisplayState.allCases.first ?? .settings
    }
    
    func changeDisplay(to newDisplay: DisplayState) {
        detailPath = .init()
        path = .init()
        mainDisplay = newDisplay
    }
    
    func pushView(_ display: DetailPath, isDetail: Bool) {
        if isDetail {
            detailPath.append(display)
        } else {
            path.append(display)
        }
    }
    
    func popView(fromDetail: Bool) {
        if fromDetail {
            detailPath.removeLast()
        } else {
            
            path.removeLast()
        }
    }
}


// MARK: - Lazy Split View Model
@MainActor final class LazySplitViewModel: ObservableObject {
    @Published var colVis: NavigationSplitViewVisibility = .detailOnly
    @Published var prefCol: NavigationSplitViewColumn = .detail
    @Published var detailPath: NavigationPath = .init()
    
    init() {
        configNavSubscribers()
        configAuthSubscribers()
    }

    func setLandscape(to isLandscape: Bool) {
        if isLandscape {
            hideMenu()
        }
    }
    
    // MARK: - Menu
    @Published var currentMenuVis: MenuVisibility = .hidden
    
    /// Used by the custom sidebar toggle button found in the parent NavigationSplitView's toolbar. The parent split view only has two columns, so when the columnVisibility is .doubleColumn the menu is open. When it's .detailOnly it is closed.
    ///     Preferred compact column is used to which views are displayed on smaller screen sizes. When the menu is open (colVis == .doubleColumn) we want  users on smaller devices to only see the menu.
    ///     Making prefCol toggle between detail and sidebar allows users on smaller devices to close the menu by tapping the same button they used to open it. If prefCol were always set to sidebar after tap, the menu wont close on iPhones.
    func sidebarToggleTapped() {
        colVis = colVis == .doubleColumn ? .detailOnly : .doubleColumn
        prefCol = colVis == .detailOnly ? .detail : .sidebar
    }
    
    func showMenu() {
        guard colVis != .doubleColumn && prefCol != .sidebar else { return }
        colVis = .doubleColumn
        prefCol = .sidebar
    }
    
    func hideMenu() {
        guard colVis != .detailOnly && prefCol != .detail else { return }
        colVis = .detailOnly
        prefCol = .detail
    }
    
    // MARK: - Navigation Subscriptions
    private let navService = LazyNavService.shared
    @Published var path: NavigationPath = .init()
    @Published var mainDisplay: DisplayState = .makeASale
    
    func configNavSubscribers() {
        navService.$mainDisplay
            .sink { [weak self] display in
                print("Display subscription notified")
                self?.mainDisplay = display
            }
            .store(in: &cancellables)
        
        navService.$path
            .sink { [weak self] path in
                print("Path subscription notified")
                self?.path = path
                
            }
            .store(in: &cancellables)
        
        navService.$detailPath
            .sink { [weak self] detailPath in
                print("Detail path subscription notified")
                self?.detailPath = detailPath
                print(self?.detailPath.isEmpty)
            }
            .store(in: &cancellables)
    }
    

    
    // MARK: - Authentication / Onboarding
    private let service = AuthService.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var exists: Bool = false

    func configAuthSubscribers() {
        service.$exists
            .sink { [weak self] exists in
                self?.exists = exists
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Onboarding
    func finishOnboarding() {
        exists = true
        mainDisplay = .makeASale
    }
}

struct LazySplit<S: View, C: View, T: ToolbarContent>: View {
    @StateObject var vm: LazySplitViewModel
    @Environment(\.horizontalSizeClass) var horSize
    @Environment(\.verticalSizeClass) var verSize
    
    @State var childColVis: NavigationSplitViewVisibility = .doubleColumn
    @State var childPrefCol: NavigationSplitViewColumn = .content
    
    let sidebar: S
    let content: C
    let toolbarContent: T
    
    init(viewModel: LazySplitViewModel, sidebar: (() -> S), content: (() -> C), toolbar: (() -> T)) {
        self._vm = StateObject(wrappedValue: viewModel)
        self.sidebar = sidebar()
        self.content = content()
        self.toolbarContent = toolbar()
    }
        
    var body: some View {
        GeometryReader { geo in
            let isLandscape = geo.size.width > geo.size.height
            
            NavigationStack(path: $vm.path) {
                NavigationSplitView(columnVisibility: $vm.colVis,  preferredCompactColumn: $vm.prefCol) {
                    sidebar
                        .onAppear {
                            vm.currentMenuVis = .visible
                        }
                        .onDisappear {
                            vm.currentMenuVis = .hidden
                        }
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar(removing: .sidebarToggle)
                } detail: {
                    Group {
                        if vm.mainDisplay.displayMode == .besideDetail {
                            NavigationSplitView(columnVisibility: $childColVis, preferredCompactColumn: $childPrefCol) {
                                content
                                    .toolbar(.hidden, for: .navigationBar)
                            } detail: { 
                                NavigationStack(path: $vm.detailPath) {
//                                    
//                                    EmptyView()
//                                        .onAppear {
//                                            print("Empty view appeared")
//                                        }
//                                        .navigationDestination(for: DetailPath.self) { detail in
//                                            switch detail {
//                                            case .item(let i, let t):       ItemDetailView(item: i, detailType: t)
//                                            case .confirmSale: ConfirmSaleView() //Fix this, pass VM to enum so it can be accessed
////                                                    .environmentObject(vm)
//                                                
//                                            case .department(let d, let t): DepartmentDetailView(department: d, detailType: t)
//                                            case .company(let c, let t):    CompanyDetailView(company: c, detailType: t)
//                                                
//                                            case .passcodePad(let p):
//                                                PasscodeView(processes: p) {
//                                                    LazyNavService.shared.pushView(.department(nil, .onboarding), isDetail: true)
//                        //                                vm.pushView(DetailPath.department(nil, .onboarding))
//                                                }
//                                            }
//                                        }
                                }
//                                .onAppear {
//                                    print("Nav stack appeared")
//                                }
//                                .onDisappear {
//                                    print("Nav stack disappeared")
//                                }
                            }
                            .navigationSplitViewStyle(.balanced)
                            .toolbar(removing: .sidebarToggle)
                        } else {
                            content
                        }
                    }
                    .toolbar(.hidden, for: .navigationBar)
                }
                .navigationDestination(for: DetailPath.self) { detail in
                    switch detail {
                    case .confirmSale:
                        ConfirmSaleView()
                            .environmentObject(vm)
                        
                    default: Color.red
                    }
                }
                .navigationTitle(vm.mainDisplay.viewTitle)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(removing: .sidebarToggle)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    sidebarToggle
                    toolbarContent
                }
                .modifier(LazySplitMod(isProminent: !isLandscape))
                // For primary stack

                
            } //: Navigation Stack
            .onChange(of: isLandscape) { prev, landscape in
                print("Orientation changed from \(prev) to \(landscape)")
                if landscape {
                    vm.hideMenu()
                }
            }
            .onReceive(vm.$mainDisplay) { newDisplay in
                print("Display received: \(newDisplay). Hiding menu.")
                vm.hideMenu()
            }
//            .environmentObject(vm)
            
        }
    } //: Body
    
    
    @ToolbarContentBuilder var sidebarToggle: some ToolbarContent {
        let isIphone = horSize == .compact || verSize == .compact
        let isXmark = isIphone && vm.currentMenuVis == .visible && vm.prefCol == .sidebar
        
        ToolbarItem(placement: .topBarLeading) {
            Button("Close", systemImage: isXmark ? "xmark" : "sidebar.leading") {
                vm.sidebarToggleTapped()
            }
        }
        
    }
    
    struct LazySplitMod: ViewModifier {
        let isProminent: Bool
        func body(content: Content) -> some View {
            if isProminent {
                content
                    .navigationSplitViewStyle(.prominentDetail)
            } else {
                content
                    .navigationSplitViewStyle(.balanced)
            }
        }
    }
    
    
}

//// A: Hides the default toggle that appears on the detail column on iPads
//// B: Adds the custom toggle to replace the default sidebar toggle
//// C: Hides the back button that appeaers on the detail of the iPhone 15 Pro in landscape
//
//struct LazyNavView<S: View, C: View>: View {
//    @EnvironmentObject var vm: LazyNavViewModel
//    @Environment(\.horizontalSizeClass) var horSize
//    @Environment(\.verticalSizeClass) var verSize
//    
//    let sidebar: S
//    let content: C
//    
//    init(@ViewBuilder sidebar: (() -> S), @ViewBuilder content: (() -> C)) {
////        print("Lazy Nav Initialized")
//        self.sidebar = sidebar()
//        self.content = content() 
//    }
//    
//    var body: some View {
//        GeometryReader { geo in
//            let isLandscape = geo.size.width > geo.size.height
//            let isIphone = horSize == .compact || verSize == .compact
//            // The split view needs to be balanced if the main display is in the sidebar column because if they're prominent you can close them by tapping the darkened area on the right. In the settings view, the column on the right can be an empty view which doesn't have a menu button.
////            let c2 = vm.mainDisplay.prefCol != .left
//            NavigationSplitView(columnVisibility: $vm.colVis, preferredCompactColumn: $vm.prefCol) {
//                NavigationStack(path: $vm.sidebarPath) {
//                    sidebar
//                }
//                .toolbar(removing: .sidebarToggle) // - A
//            } detail: {
//                NavigationStack(path: $vm.contentPath) {
//                    content
//                        .frame(width: geo.size.width)
//                        .toolbar(removing: .sidebarToggle)
//                }
//                .navigationBarBackButtonHidden(true) // - C
//                .toolbar {
//                    if vm.mainDisplay.prefCol == .center {
//                        SidebarToggle()
//                    }
//                } // - B
//            }
//            .modifier(LazyNavMod(isProminent: isIphone && horSize != .regular))
//            .environmentObject(vm)
//            
//            // The menu closes on iPad when the navigationSplitViewStyle is .balanced and the device orientation changes from landscape to portrait. This causes an issue on settings because the whole screen will be blank when the right column's view is empty and the device orientation changes.
//
//            // The detail could be empty or without a back button/sidebar toggle, so when the view changes to detail only and the current primary view is not in the full screen primary view location, and there isn't another detail view open to the right of the sidebar, then the user needs to see the view that is currently in the sidebar column.
//            .onChange(of: $vm.colVis.wrappedValue) { oldValue, newValue in
//                if newValue == .detailOnly && vm.mainDisplay.prefCol != .center {
//                    withAnimation(.interpolatingSpring) {
//                        vm.colVis = .doubleColumn
//                    }
//                }
//            }
//            .onChange(of: isLandscape) { _, newValue in
////                vm.setLandscape(to: newValue)
//            }
//        }
//    } //: Body
//    
//    // Creates lag when tapping a menu button from a screen that is balanced to a screen that is prominent.
//    //  - Maybe try forcing a delay so the change happens when the menu is closed?
//    struct LazyNavMod: ViewModifier {
//        let isProminent: Bool
//        func body(content: Content) -> some View {
//            if isProminent {
//                content
//                    .navigationSplitViewStyle(.prominentDetail)
//            } else {
//                content
//                    .navigationSplitViewStyle(.balanced)
//            }
//        }
//    }
//    
//    struct SidebarToggle: ToolbarContent {
//        @EnvironmentObject var vm: LazyNavViewModel
//        @ToolbarContentBuilder var body: some ToolbarContent {
//            ToolbarItem(placement: .topBarLeading) {
//                Button("Menu", systemImage: "sidebar.leading") {
//                    withAnimation {
//                        vm.toggleSidebar()
//                    }
//                }
//            }
//        }
//    }
//    
//}
//
//
//#Preview {
//    ResponsiveView { props in
//        RootView(UI: props)
//            .environment(\.realm, DepartmentEntity.previewRealm)
//    }
//}
//
//
//
