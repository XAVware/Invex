//
//  LSXViewModel.swift
//  LazySplitX
//
//  Created by Ryan Smetana on 7/22/24.
//

import SwiftUI
import Combine

@MainActor final class LSXViewModel: ObservableObject {
    private let navService = LSXService.shared
    
    @Published var colVis: NavigationSplitViewVisibility = .detailOnly
    @Published var prefCol: NavigationSplitViewColumn = .detail
    
    @Published var primaryPath: NavigationPath = .init()
    @Published var detailPath: NavigationPath = .init()
    
    @Published var mainDisplay: LSXDisplay = .pos
    @Published var detailRoot: LSXDisplay?
    
    private var isCompact: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        configNavSubscribers()
    }
    
    func sidebarToggleTapped() {
        colVis = colVis == .doubleColumn ? .detailOnly : .doubleColumn
        prefCol = colVis == .detailOnly ? .detail : .sidebar
    }
    
    func showMenu() {
        colVis = .doubleColumn
        prefCol = .sidebar
        detailRoot = nil
    }
    
    func hideMenu() {
        colVis = .detailOnly
        prefCol = .detail
    }
    
    func configNavSubscribers() {
        // Receive a main view
        navService.pathView
            .filter({ $0.1 == .primary })
            .sink { [weak self] (view, prefColumn) in
                if LSXDisplay.allCases.contains(view) {
                    self?.changeDisplay(to: view)
                } else {
                    self?.pushPrimary(view)
                }
                
            }.store(in: &cancellables)
        
        // Receive a detail view
        navService.pathView
            .filter({ $0.1 == .detail })
            .sink { [weak self] (display, prefColumn) in
                self?.pushDetail(display)
            }.store(in: &cancellables)
    }
    
    
    /// Changes the root view to one of LSXDisplay.allCases
    private func changeDisplay(to newDisplay: LSXDisplay) {
        hideMenu()
        detailPath = .init()
        primaryPath = .init()
        mainDisplay = newDisplay
    }
    
    /// Pushes a view onto the full screen position
    private func pushPrimary(_ display: LSXDisplay) {
        primaryPath.append(display)
    }
    
    private func pushDetail(_ display: LSXDisplay) {
        if isCompact || mainDisplay.displayMode == .detailOnly || primaryPath.count != 0 {
            self.pushPrimary(display)
        } else {
            if detailRoot == nil {
                detailRoot = display
            } else {
                detailPath.append(display)
            }
        }
    }
    
    func setHorIsCompact(isCompact: Bool) {
        self.isCompact = isCompact
    }
}
