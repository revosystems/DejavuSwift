import SwiftUI

public class Dejavu {
    public static var bundle:Bundle {
        Bundle.module
    }
    
    // MARK: - Colors
    public static var brand : Color {
        Color("brand", bundle: self.bundle)
    }
    
    public static var headerDark : Color {
        Color("header-dark", bundle: self.bundle)
    }
    
    public static var headerLighter : Color {
        Color("header-lighter", bundle: self.bundle)
    }
    
    public static var headerSemi : Color {
        Color("header-semi", bundle: self.bundle)
    }
    
    public static var sidebar : Color {
        Color("sidebar", bundle: self.bundle)
    }
    
    public static var textPrimary : Color {
        Color("text-primary", bundle: self.bundle)
    }
    
    public static var textSecondary : Color {
        Color("text-secondary", bundle: self.bundle)
    }
    
    public static var textTernary : Color {
        Color("text-ternary", bundle: self.bundle)
    }
    
    public static var background : Color {
        Color("background", bundle: self.bundle)
    }
    
    public static var backgroundDarker : Color {
        Color("background-darker", bundle: self.bundle)
    }
    
    public static var brokenWhite: Color {
        Color("broken-white", bundle: self.bundle)
    }
    
    public static var tableBackground: Color {
        Color("table-background", bundle: self.bundle)
    }

    public static func image(_ name:String) -> Image? {
        Image(name, bundle: self.bundle)
    }
    
    static func trans(_ key: String) -> String{
        let language = UserDefaults.standard.string(forKey: "language") ?? "en"
        return NSLocalizedString(key, tableName: language, comment: "")
    }
    
    static func imageFor(_ name: String) -> Image {
        let uiImage = UIImage(systemName: name) ??
        UIImage(named: name, in: Dejavu.bundle, with: nil) ??
        UIImage(named: name) ??
        UIImage()
        return Image(uiImage: uiImage).renderingMode(.template)
    }
}

#Preview("Brand Colors") {
    VStack(spacing: 20) {
        ColorSwatchView(color: Dejavu.brand, name: "Brand", code: "Dejavu.brand")
    }
    .padding()
    .frame(maxWidth: 250)
    .border(.black)
}

#Preview("Header Colors") {
    VStack(spacing: 20) {
        ColorSwatchView(color: Dejavu.headerDark, name: "Header Dark", code: "Dejavu.headerDark")
        ColorSwatchView(color: Dejavu.headerLighter, name: "Header Lighter", code: "Dejavu.headerLighter")
        ColorSwatchView(color: Dejavu.headerSemi, name: "Header Semi", code: "Dejavu.headerSemi")
    }
    .padding()
    .frame(maxWidth: 250)
    .border(.black)
}

#Preview("Text Colors") {
    VStack(spacing: 20) {
        ColorSwatchView(color: Dejavu.textPrimary, name: "Text Primary", code: "Dejavu.textPrimary")
        ColorSwatchView(color: Dejavu.textSecondary, name: "Text Secondary", code: "Dejavu.textSecondary")
        ColorSwatchView(color: Dejavu.textTernary, name: "Text Ternary", code: "Dejavu.textTernary")
    }
    .padding()
    .frame(maxWidth: 250)
    .border(.black)
}

#Preview("Background Colors") {
    VStack(spacing: 20) {
        ColorSwatchView(color: Dejavu.background, name: "Background", code: "Dejavu.background")
        ColorSwatchView(color: Dejavu.backgroundDarker, name: "Background Darker", code: "Dejavu.backgroundDarker")
        ColorSwatchView(color: Dejavu.brokenWhite, name: "Broken White", code: "Dejavu.brokenWhite")
        ColorSwatchView(color: Dejavu.tableBackground, name: "Table Background", code: "Dejavu.tableBackground")
    }
    .padding()
    .frame(maxWidth: 250)
    .border(.black)
}

#Preview("Sidebar Color") {
    VStack(spacing: 20) {
        ColorSwatchView(color: Dejavu.sidebar, name: "Sidebar", code: "Dejavu.sidebar")
    }
    .padding()
    .frame(maxWidth: 250)
    .border(.black)
}

struct ColorSwatchView: View {
    let color: Color
    let name: String
    let code: String
    
    var body: some View {
        VStack(spacing: 8) {
            Rectangle()
                .fill(color)
                .frame(height: 60)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            
            Text(name)
                .font(.system(size: 12, weight: .semibold))
            
            Text(code)
                .font(.system(size: 10, design: .monospaced))
                .foregroundColor(.secondary)
        }
    }
}
