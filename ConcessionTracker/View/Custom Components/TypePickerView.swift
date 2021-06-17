

import SwiftUI

struct TypePickerView: View {
    @Binding var typeID: Int
    
    var body: some View {
//        Picker(selection: $typeID, label: Text("")) {
//            ForEach(0 ..< concessionTypes.count) { index in
//                Text(concessionTypes[index].type).foregroundColor(.black).tag(index)
//            }
//        }
        Picker(selection: $typeID, label: Text("")) {
            ForEach(0 ..< categoryList.count) { index in
                Text(categoryList[index].name).foregroundColor(.black).tag(index)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .frame(maxWidth: 400)
        .padding(.top)
        .padding(.bottom, 10)
    }

}
