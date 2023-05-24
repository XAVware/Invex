
import SwiftUI

struct PreviewMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (4th generation)"))
            .previewInterfaceOrientation(.landscapeLeft)
            .environment(\.realmConfiguration, MockRealms.config)
    }
}
