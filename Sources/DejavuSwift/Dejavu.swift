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
