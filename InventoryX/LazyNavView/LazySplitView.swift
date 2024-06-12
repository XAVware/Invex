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
enum LazySplitColumn { case leftSidebar, primaryContent, detail, rightSidebar }

// Does this need to be a main actor?
@MainActor class LazyNavService {
    @Published var primaryRoot: DisplayState
    @Published var detailRoot: DetailPath?
    
    
    // TODO: Make these passthrough?
    @Published var primaryPath: NavigationPath = .init()
    @Published var detailPath: NavigationPath = .init()
    
    static let shared = LazyNavService()
    
    init() {
        self.primaryRoot = DisplayState.allCases.first ?? .settings
    }
    
    func changeDisplay(to newDisplay: DisplayState) {
        detailPath = .init()
        primaryPath = .init()
        primaryRoot = newDisplay
    }
    
    func pushPrimary(_ display: DetailPath, isDetail: Bool) {
        primaryPath.append(display)
//        if isDetail {
//            if detailRoot == nil {
//                detailRoot = display
//            } else {
//                detailPath.append(display)
//            }
//        } else {
//            primaryPath.append(display)
//        }
    }
    
    func setDetailRoot(_ view: DetailPath) {
        self.detailRoot = view
    }
    
    /// Only call this from views appearing after the detail root
    func pushDetail(view: DetailPath) {
//        if detailRoot == nil {
//            detailRoot = view
//        } else {
            detailPath.append(view)
//        }
    }
    
    func popPrimary() {
        primaryPath.removeLast()
    }
    
    func popDetail() {
        if detailPath.isEmpty {
            detailRoot = nil
        } else {
            detailPath.removeLast()
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
    @Published var mainDisplay: DisplayState = .makeASale
    @Published var detailRoot: DetailPath?
    @Published var path: NavigationPath = .init()
    
    func configNavSubscribers() {
        navService.$primaryRoot
            .sink { [weak self] display in
                self?.mainDisplay = display
            }.store(in: &cancellables)
        
        navService.$detailRoot
            .sink { [weak self] detailPath in
                self?.detailRoot = detailPath
            }.store(in: &cancellables)
        
        navService.$primaryPath
            .sink { [weak self] path in
                self?.path = path
                
            }.store(in: &cancellables)
        
        navService.$detailPath
            .sink { [weak self] detailPath in
                self?.detailPath = detailPath
            }.store(in: &cancellables)
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

struct LazySplit<S: View, C: View, T: ToolbarContent, D: View>: View {
    @StateObject var vm: LazySplitViewModel
    @Environment(\.horizontalSizeClass) var horSize
    @Environment(\.verticalSizeClass) var verSize
    
    @State var childColVis: NavigationSplitViewVisibility = .doubleColumn
    @State var childPrefCol: NavigationSplitViewColumn = .content
    
    let sidebar: S
    let content: C
    let contentToolbar: T
    let detail: D
    
    init(viewModel: LazySplitViewModel, sidebar: (() -> S), content: (() -> C), contentToolbar: (() -> T), detail: (() -> D)) {
        self._vm = StateObject(wrappedValue: viewModel)
        self.sidebar = sidebar()
        self.content = content()
        self.contentToolbar = contentToolbar()
        self.detail = detail()
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
                                    detail
                                }
                                .navigationDestination(for: DetailPath.self) { detail in
                                    switch detail {
                                    case .item(let i, let t):       ItemDetailView(item: i, detailType: t)
                                    default: Color.blue
                                    }
                                    
                                }
                            }
                            .navigationBarTitleDisplayMode(.inline)
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
                    contentToolbar
                }
                .modifier(LazySplitMod(isProminent: !isLandscape))

                
            } //: Navigation Stack
            // I intentionally put the hide/show menu functions in the view. I think it was causing issues with the menu animations, but it should be tested & compared to calling from VM.
            .onChange(of: isLandscape) { prev, landscape in
                if landscape {
                    vm.hideMenu()
                }
            }
            .onReceive(vm.$mainDisplay) { newDisplay in
                vm.hideMenu()
            }
            .onReceive(vm.$detailRoot) { detailRoot in
                // Pushing a view into the detail column by itself only works for iPad. childPrefCol needs to toggle between content and detail for iPhone.
                print("Detail root received: \(detailRoot)")
                self.childPrefCol = detailRoot != nil ? .detail : .content
            }
            .onReceive(vm.$detailPath) { detailPath in
                print("Detail path received: \(detailPath). Size \(detailPath.count)")
            }
                        
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

#Preview {
    RootView()
        .environment(\.realm, DepartmentEntity.previewRealm)
}
