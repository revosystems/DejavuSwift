import SwiftUI

public struct SearchBar: View {
    @Binding var text: String
    let placeholder: String
    let backgroundColor: Color
    let foregroundColor: Color
    let withClearButton: Bool
    
    public init(text: Binding<String>, placeholder: String?, backgroundColor: Color = Color(.systemGray6), withClearButton: Bool = true, foregroundColor: Color = .secondary) {
        self._text = text
        self.placeholder = placeholder ?? __("search")
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.withClearButton = withClearButton
    }
    
    public var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(foregroundColor)
            
            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
            
            if withClearButton && !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(foregroundColor)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(backgroundColor)
        .cornerRadius(10)
    }
}
