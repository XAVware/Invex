

import SwiftUI

struct TypeSelectorView: View {
    @Binding var selectedType: String
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                ForEach(concessionTypes) { concessionType in
                    Button(action: {
                        self.selectedType = concessionType.type
                    }) {
                        HStack {
                            Text(concessionType.type)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            RightChevron()
                        } //: HStack
                    } //: Button - ConcessionType
                    .foregroundColor(Color.black)
                    .font(.system(size: 18, weight: self.selectedType == concessionType.type ? .semibold : .light, design: .rounded))
                    .padding(.horizontal)
                    .frame(height: 40)
                    .background(self.selectedType == concessionType.type ? Color.gray.opacity(0.8) : Color.clear)
                    
                    Divider()
                } //: ForEach
            } //: VStack
        } //: ScrollView
    }
}

