import SwiftUI
import Foundation

@available(iOS 15.0, *)
public struct OutlinedTextFieldStyle: TextFieldStyle {
    
    @State var icon: Image?
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        HStack {
            if icon != nil {
                icon
                    .foregroundColor(Color.secondary)
            }
            configuration
        }
        .padding(6)
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(Color.secondary, lineWidth: 1)
        }
    }
}
