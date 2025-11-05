import Foundation
import SwiftUI

func __(_ key: String) -> String{
    let language = UserDefaults.standard.string(forKey: "language") ?? "en"
    return NSLocalizedString(key, tableName: language, comment: "")
}

func isIpad() -> Bool{
    UIDevice().userInterfaceIdiom == .pad
}

func imageFor(_ name: String) -> Image {
    let uiImage = UIImage(systemName: name) ??
        UIImage(named: name, in: Dejavu.bundle, with: nil) ??
        UIImage(named: name) ??
        UIImage()
    return Image(uiImage: uiImage).renderingMode(.template)
}
