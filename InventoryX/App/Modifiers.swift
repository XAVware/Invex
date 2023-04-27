
import SwiftUI

struct TitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .center)
            .font(.system(size: 24, weight: .semibold, design: .rounded))
            .foregroundColor(primaryColor)
            .padding()
    }
}

struct HeaderModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .foregroundColor(primaryColor)
            .frame(maxWidth: .infinity, maxHeight: 40)
    }
}

struct PlusMinusButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .scaledToFit()
            .shadow(radius: 2)
            .frame(width: 40)
            .foregroundColor(primaryColor)
    }
}

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 18, weight: .bold, design: .rounded))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .autocapitalization(UITextAutocapitalizationType.words)
    }
}

struct MenuButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 24, weight: .semibold, design: .rounded))
            .frame(height: 60)
            .foregroundColor(.white)
    }
}

struct SaveButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 24, weight: .semibold, design: .rounded))
            .frame(maxWidth: 500, minHeight: 60)
            .background(Color("GreenBackground"))
    }
}

struct DetailTextModifier: ViewModifier {
    @State var textColor: Color = Color.white
    func body(content: Content) -> some View {
        content
            .padding(.horizontal)
            .padding(.bottom, 5)
            .font(.system(size: 16))
            .foregroundColor(self.textColor)
    }
}

struct TitleDetailModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16))
            .padding(.bottom)
    }
}

struct IpadMiniPreviewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .previewLayout(.fixed(width: 1024, height: 768))
    }
}


struct PreviewMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (4th generation)"))
            .previewInterfaceOrientation(.landscapeLeft)
            .environment(\.realmConfiguration, MockRealms.config)
    }
}
