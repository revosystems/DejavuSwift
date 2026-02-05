import SwiftUI


@available(iOS 15.0, *)
public struct ToolbarCloseButtonModifier: ViewModifier {
    @Environment(\.dismiss) private var dismiss
    let action: () -> Void
    
    public func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        action()
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .padding(12)
                    }
                }
            }
    }
}

@available(iOS 15.0, *)
extension View {
    public func toolbarCloseButton(action: @escaping () -> Void = {}) -> some View {
        modifier(ToolbarCloseButtonModifier(action: action))
    }
}
