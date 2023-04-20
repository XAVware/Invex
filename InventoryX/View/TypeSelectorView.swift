

import SwiftUI

struct TypeSelectorView: View {
    @Binding var selectedType: String
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                ForEach(categoryList, id: \.self) { category in
                    Button(action: {
                        self.selectedType = category.name
                    }) {
                        HStack {
                            Text(category.name)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            RightChevron()
                        } //: HStack
                    } //: Button - ConcessionType
                    .foregroundColor(Color.black)
                    .font(.system(size: 18, weight: self.selectedType == category.name ? .semibold : .light, design: .rounded))
                    .padding(.horizontal)
                    .frame(height: 40)
                    .background(self.selectedType == category.name ? Color.gray.opacity(0.8) : Color.clear)
                    
                    Divider()
                } //: ForEach
            } //: VStack
        } //: ScrollView
    }
}

