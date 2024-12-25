//
//  FormX.swift
//  InventoryX
//
//  Created by Ryan Smetana on 11/1/24.
//

import SwiftUI

/*
 Validation:
 TextFieldX accepts validation logic as a parameter to improve robustness. More specific fields, like CurrencyFieldX, handle validation within their view since validating a formatted currency remains consistent across use cases.
 */

// MARK: - View Model
@Observable
class FormXViewModel {
    var origValue: String = ""
    var showAlert: Bool = false
    
    var onTapOutside: (() -> Void)?
    var expandedContainer: UUID?
    var containers: [ContainerXModel] = []
    
    /// When a container is initially expanded, the string version of the container's value is set.
    func setOrigValue(_ value: String) {
        self.origValue = value
    }
    
    /// Force the container to close, discarding any unsaved changes.
    func forceClose() {
        withAnimation {
            expandedContainer = nil
        }
    }
    
    func toggleContainer(id: UUID) {
        withAnimation {
            expandedContainer = expandedContainer == id ? nil : id
        }
    }
    
    func expandContainer(id: UUID) {
        withAnimation {
            expandedContainer = id
        }
    }
    
    /// Confirms the container's value has not changed
    func closeContainer(withValue currentVal: String) {
        guard self.origValue == currentVal else {
            showAlert = true
            return
        }
        
        withAnimation {
            expandedContainer = nil
        }
        return
    }
}

// MARK: - Form X View
struct FormX<C: View>: View {
    @Environment(\.horizontalSizeClass) var hSize
    @State var formVM: FormXViewModel = FormXViewModel()
    
    let content: C
    let title: String
    
    init(title: String, @ViewBuilder content: (() -> C)) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                if formVM.expandedContainer == nil {
                    Text(title)
                        .font(.largeTitle)
                        .fontDesign(.rounded)
                        .padding(.top, 4)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    content
                }
                .padding(.vertical)
                .environment(formVM)
            } //: VStack
            .padding(hSize == .regular ? 48 : 16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .fontDesign(.rounded)
            .transition(.blurReplace)
            
        } //: Scroll View
        .background(.bg)
        .scrollIndicators(.hidden)
        .toolbar(formVM.expandedContainer == nil ? .visible : .hidden, for: .navigationBar)
    }
    
}

/// Used for read-only sections
struct FormSectionX<C: View>: View {
    @Environment(\.horizontalSizeClass) var hSize
    
    let content: C
    @State var title: String = ""
    
    init(title: String, @ViewBuilder content: (() -> C)) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 6) {
                content
            } //: VStack
            .background(Color.fafafa)
        } //: VStack
    }
}


