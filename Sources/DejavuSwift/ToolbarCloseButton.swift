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


#Preview {
    if #available(iOS 16.0, *) {
        NavigationView {
            VStack(spacing: 0) {
                Text("Example View")
                    .frame(maxWidth: .infinity)
                
                Spacer()
                
                Button("Next") {/* Handle press */}
                .padding()
            }
            .navigationTitle("Navigation Title")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarCloseButton(action: {
                print("View was closed!")
            })
            .background(.blue.opacity(0.1))
        }
        .navigationViewStyle(.stack)
        .frame(maxWidth: 300, maxHeight: 200)
        .border(.black)
    }
}
