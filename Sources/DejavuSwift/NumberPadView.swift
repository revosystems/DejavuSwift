import SwiftUI

public struct NumberPadView: View {
    
    let confirm: ((Double) -> Void)?
    
    @Binding var value: Double
    let allowDecimals: Bool
    
    @State private var input: String {
        didSet {
            value = formatValue()
        }
    }
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    public init(value: Binding<Double>, allowDecimals: Bool = false, confirm: ((Double) -> Void)? = nil) {
        self._value = value
        self.allowDecimals = allowDecimals
        self.confirm = confirm
        self._input = State(initialValue: Self.formatInitialValue(value.wrappedValue, allowDecimals: allowDecimals))
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            Text(formatDisplay())
                .font(.largeTitle)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(4)
                .onAppear {
                    input = Self.formatInitialValue(value, allowDecimals: allowDecimals)
                }
            
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(1...9, id: \.self) { number in
                    Button(action: {
                        addNumber(String(number))
                    }) {
                        Text("\(number)")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                    }
                }
                
                Button(action: {
                    removeNumber()
                }) {
                    Image(systemName: "delete.left")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(4)
                }
                
                Button(action: {
                    addNumber("0")
                }) {
                    Text("0")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(4)
                }
                
                if (confirm != nil) {
                    Button(action: {
                        confirmInput()
                    }) {
                        Image(systemName: "checkmark")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .frame(height:60)
                            .background(Dejavu.brand)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            Spacer()
        }
    }
    
    private func addNumber(_ number: String) {
        if !allowDecimals {
            if input == "0" {
                input = number
                return
            }
            
            input += number
        }
        
        if input.count < 10 {
            input.append(number)
            input = String(input.suffix(10)) // Manté màxim 10 digits
        }
    }
    
    private func removeNumber() {
        if !allowDecimals {
            input = String(input.dropLast())
            if input.isEmpty { input = "0" }
            
            return
        }
        
        input = "0" + input.dropLast()
        if input.count < 3 { input = "000" }
    }
    
    private func formatValue() -> Double {
        if !allowDecimals {
            return Double(input) ?? 0
        }
            
        return (Double(input) ?? 0) / 100.0
    }
    
    private func formatDisplay() -> String {
        let number = formatValue()
        return allowDecimals ? String(format: "%.2f", number) : String(Int(number))
    }
    
    private func confirmInput() {
        confirm?(value)
    }
    
    private static func formatInitialValue(_ value: Double, allowDecimals: Bool) -> String {
        if allowDecimals {
            return String(format: "%03d", Int(value * 100))
        } else {
            return String(Int(value))
        }
    }
}

#Preview {
    struct Preview: View {
        @State var value1: Double = 12.34
        @State var value2: Double = 56.0
        
        var body: some View {
            VStack {
                Text("Mode Decimals")
                NumberPadView(value: $value1, allowDecimals: true)
                
                Divider()
                
                Text("Mode Enters")
                NumberPadView(value: $value2, allowDecimals: false)
            }
        }
    }
    return Preview()
}
