import Foundation
import SwiftUI

extension Dejavu {
    static func trans(_ key: String) -> String{
        let language = UserDefaults.standard.string(forKey: "language") ?? "en"
        return NSLocalizedString(key, tableName: language, comment: "")
    }
    
    @MainActor static func isIpad() -> Bool{
        UIDevice().userInterfaceIdiom == .pad
    }
    
    static func imageFor(_ name: String) -> Image {
        let uiImage = UIImage(systemName: name) ??
        UIImage(named: name, in: Dejavu.bundle, with: nil) ??
        UIImage(named: name) ??
        UIImage()
        return Image(uiImage: uiImage).renderingMode(.template)
    }
}
