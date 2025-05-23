import SwiftUI

public extension Color {
    public func luminance() -> Double {
        let uiColor = UIColor(self)
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: nil)

        return 0.2126 * Double(red) + 0.7152 * Double(green) + 0.0722 * Double(blue)
    }
    
    public func isLight() -> Bool {
        return luminance() > 0.5
    }
    
    public func contrastedTextColor() -> Color {
        return isLight() ? Color.black : Color.white
    }
}
