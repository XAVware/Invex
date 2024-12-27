//
//  FormX.swift
//  InventoryX
//
//  Created by Ryan Smetana on 11/1/24.
//

import SwiftUI

/*
 FormX provides reusable structure for CRUD fields.
 
 Behavior:
 - Content is displayed in a scrollview and has a background color 0.5% darker than the default background color.
    - This slight color difference is virtually unnoticeable but subtly guide's the user's eyes to the content.
 - Content is padded based on the `HorizontalSizeClass` - `.regular` size class is padded slightly more than `.compact` sizes.
    - This helps the content not appear too large on iPad or Mac apps that have large windows.
 - Title and tab bar are hidden when a child container is opened/expanded.
 - When a container is opened, all other containers are hidden.
 - Containers are separated by dividers automatically
 
 Containers:
 - Containers have a Title, Description, and Value.
 - When the container is opened, its title appears as the FormX title
 - When the container is closed, the title is displayed along with either the description or value. If a value hasn't been entered yet, the description is displayed.
 
 
 
 Navigation:
 - Save & cancel buttons are included in containers.
    - Save: Saving performs the field's validation rules before passing the new value back to its parent.
    - Cancel: Containers pass their initial value to the `FormXViewModel` when they are expanded. When the user taps cancel the current value is compared to the initial value.
        - If the values are different the user is prompted with an alert that there are unsaved changes.
        - If values have not changed the container will close without prompting the user further.
 
 TextFieldX:
 - Validation: Accepts validation logic as a parameter to improve robustness. More specific fields, like CurrencyFieldX, handle validation within their view since validating a formatted currency remains consistent across use cases.
 - Errors: If validation conditions aren't met the text field is tinted red and the error message is displayed below it.
 - A value is only returned if it meets validation rules so its parent is guaranteed to receive formatted data.
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
        print("Closing container. Original: \(origValue). New: \(currentVal)")
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
                // The page title is hidden if a container is expanded
                if formVM.expandedContainer == nil {
                    Text(title)
                        .font(.largeTitle)
                        .fontDesign(.rounded)
                        .padding(.top, 4)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    content
                }
                .background(Color.bg100.clipShape(RoundedRectangle(cornerRadius: 8)).padding(-12))
                .padding(.vertical)
                .environment(formVM)
            } //: VStack
            .padding(hSize == .regular ? 48 : 16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .fontDesign(.rounded)
            .transition(.blurReplace)
        } //: Scroll View
        .background(Color.bg)
        .scrollIndicators(.hidden)
        .toolbar(formVM.expandedContainer == nil ? .visible : .hidden, for: .navigationBar)
    } //: Body
    
}

// MARK: - FormX Section

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
        } //: VStack
    }
}


