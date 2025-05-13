import SwiftUI

@available(iOS 15.0, *)
public struct CloseButton: View {
    @Environment(\.dismiss) private var dismiss
    var icon: String
    var actionBeforeDismiss: (() -> Void)?
    
    public init(icon: String = "xmark", actionBeforeDismiss: (() -> Void)? = nil) {
        self.icon = icon
        self.actionBeforeDismiss = actionBeforeDismiss
    }

    public var body: some View {
        Button(action: {
            actionBeforeDismiss?()
            dismiss()
        }) {
            Image(systemName: icon)
                .padding(5)
        }
        .padding()
    }
}
