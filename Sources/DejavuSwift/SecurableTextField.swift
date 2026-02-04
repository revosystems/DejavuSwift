import SwiftUI

// MARK: - UITextField subclass that preserves text when toggling secure entry

final class SecureEntryTextField: UITextField, UITextFieldDelegate {
    
    var onReturn: (() -> Void)?
    var onTextChange: ((String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onReturn?()
        return true
    }
    
    // Prevents text from being cleared when toggling isSecureTextEntry
    // Source: https://stackoverflow.com/questions/7305538/uitextfield-with-secure-entry-always-getting-cleared-before-editing
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        textField.text = newText
        
        // Restore cursor position
        if let from = textField.position(from: textField.beginningOfDocument, offset: range.location + string.count),
           let to = textField.position(from: from, offset: 0) {
            textField.selectedTextRange = textField.textRange(from: from, to: to)
        }
        
        onTextChange?(newText)
        return false
    }
}

// MARK: - SwiftUI View

public struct SecurableTextField: View {
    @Binding var text: String
    var placeholder: String
    @Binding var isFocused: Bool
    var onSubmit: () -> Void
    var onClear: () -> Void
    var shouldSecure: (() -> Bool)?
    var isValid: Bool
    
    public init(
        text: Binding<String>,
        placeholder: String,
        isFocused: Binding<Bool>,
        onSubmit: @escaping () -> Void,
        onClear: @escaping () -> Void = {},
        shouldSecure: (() -> Bool)? = nil,
        isValid: Bool = true
    ) {
        self._text = text
        self.placeholder = placeholder
        self._isFocused = isFocused
        self.onSubmit = onSubmit
        self.onClear = onClear
        self.shouldSecure = shouldSecure
        self.isValid = isValid
    }
    
    public var body: some View {
        HStack {
            TextFieldRepresentable(
                text: $text,
                placeholder: placeholder,
                isFocused: $isFocused,
                isSecure: shouldSecure?() ?? false,
                onSubmit: { if isValid { onSubmit() } }
            )
            
            Spacer()
            
            if !text.isEmpty {
                Button {
                    text = ""
                    isFocused = true
                    onClear()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 14))
                        .foregroundColor(Color(UIColor.systemGray3))
                }
            }
        }
        .padding(.leading, 16)
        .padding(.trailing, 10)
        .padding(.vertical, 12)
        .frame(height: 32)
        .background(Color.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(showError ? Color.red : Color(UIColor.systemGray4), lineWidth: 1)
        )
    }
    
    private var showError: Bool {
        !isValid && !text.isEmpty
    }
}

// MARK: - UIViewRepresentable bridge

private struct TextFieldRepresentable: UIViewRepresentable {
    @Binding var text: String
    let placeholder: String
    @Binding var isFocused: Bool
    let isSecure: Bool
    let onSubmit: () -> Void
    
    func makeUIView(context: Context) -> SecureEntryTextField {
        let textField = SecureEntryTextField(frame: .zero)
        textField.placeholder = placeholder
        textField.font = .systemFont(ofSize: 15)
        textField.textColor = .label
        textField.returnKeyType = .search
        textField.onTextChange = { text = $0 }
        textField.onReturn = {
            isFocused = false
            onSubmit()
        }
        return textField
    }
    
    func updateUIView(_ textField: SecureEntryTextField, context: Context) {
        if textField.text != text {
            textField.text = text
        }
        textField.isSecureTextEntry = isSecure
        
        if isFocused && !textField.isFirstResponder {
            DispatchQueue.main.async {
                textField.becomeFirstResponder()
            }
        } else if !isFocused && textField.isFirstResponder {
            DispatchQueue.main.async {
                textField.resignFirstResponder()
            }
        }
    }
}
