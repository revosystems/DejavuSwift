import SwiftUI

public enum NumberPadMode {
    case integer, price, decimal
}

public struct NumberPadView: View {
    
    let confirm: ((Double) -> Void)?
    
    @Binding var value: Double
    let mode: NumberPadMode
    let maxDigits: Int?
    let minValue:Double?
    let maxValue:Double?
    
    private var hasDecimalPoint: Bool { input.contains(".") }
    
    @State private var input: String = "0"
    @State private var isUpdating = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    public init(
        value: Binding<Double>,
        mode: NumberPadMode = .integer,
        minValue:Double? = nil,
        maxValue:Double? = nil,
        maxDigits: Int? = nil,
        confirm: ((Double) -> Void)? = nil
    ) {
        self._value = value
        self.mode = mode
        self.minValue = minValue
        self.maxValue = maxValue
        self.maxDigits = maxDigits
        self.confirm = confirm
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            Text(formatDisplay())
                .font(.system(size: 54, weight: .light))
                .padding()
                .frame(maxWidth: .infinity)
                //.background(Color.gray.opacity(0.2))
                .cornerRadius(4)
                .onAppear {
                    input = Self.formatInitialValue(value, mode: mode)
                    applyInputChange()
                }
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(1...9, id: \.self) { number in
                    Button(action: {
                        addNumber(String(number))
                    }) {
                        Text("\(number)")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .frame(height:60)
                            .background(Dejavu.tableBackground)
                            .foregroundColor(Dejavu.textPrimary)
                            .cornerRadius(4)
                    }
                }
                
                Button(action: {
                    removeNumber()
                }) {
                    Image(systemName: "delete.left")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .frame(height:60)
                        .background(Dejavu.tableBackground)
                        .foregroundColor(Dejavu.textPrimary)
                        .cornerRadius(4)
                }
                
                Button(action: {
                    addNumber("0")
                }) {
                    Text("0")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .frame(height:60)
                        .background(Dejavu.tableBackground)
                        .foregroundColor(Dejavu.textPrimary)
                        .cornerRadius(4)
                }
                
                if mode == .decimal {
                    Button(action: { addNumber(".") }) {
                        Text(".")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .frame(height:60)
                            .background(Dejavu.tableBackground)
                            .foregroundColor(Dejavu.textPrimary)
                            .cornerRadius(4)
                    }
                }
                
                if mode == .decimal {
                    Spacer()
                }
                if (confirm != nil) {
                    Button(action: {
                        confirmInput()
                    }) {
                        Image(systemName: "checkmark")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .frame(height:60)
                            .background(Dejavu.textPrimary)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                    }
                }
                if mode == .decimal {
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
            Spacer()
        }
        .onChange(of: value) { newValue in
            guard !isUpdating else { return }
            isUpdating = true
            input = Self.formatInitialValue(newValue, mode: mode)
            isUpdating = false
        }
    }
    
    private func addNumber(_ number: String) {
        guard canAddNumber(number) else { return }
        
        switch mode {
        case .integer:
            if input == "0" { input = number }
            else { input += number }
            
        case .price:
            input = (input + number).replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
            while input.count < 3 { input = "0" + input }
            
        case .decimal:
            if number == "." && !hasDecimalPoint {
                input += "."
            } else if number != "." {
                input += number
                if hasDecimalPoint && input.components(separatedBy: ".").last?.count ?? 0 > 2 {
                    input = String(input.dropLast())
                }
            }
        }
        
        applyInputChange()
    }
    
    private func removeNumber() {
        if input.count > 1 {
            input.removeLast()
        } else {
            input = "0"
        }
        applyInputChange()
    }
    
    private func applyInputChange() {
        guard !isUpdating else { return }
        isUpdating = true
        defer { isUpdating = false }

        // Parse input to value according to mode
        var newValue: Double
        switch mode {
        case .integer: newValue = Double(input) ?? 0
        case .price: newValue = (Double(input) ?? 0) / 100.0
        case .decimal: newValue = Double(input) ?? 0.0
        }

        // Clamp to bounds if needed
        if let minValue, newValue < minValue { newValue = minValue }
        if let maxValue, newValue > maxValue { newValue = maxValue }

        // Update binding
        value = newValue

        // Ensure input string matches clamped value for each mode
        let normalized = Self.formatInitialValue(newValue, mode: mode)
        switch mode {
        case .integer: input = normalized
        case .price: input = normalized
        case .decimal:
            // Preserve a trailing decimal point if user just typed it
            if hasDecimalPoint {
                // Keep at most two fractional digits
                let parts = input.split(separator: ".", omittingEmptySubsequences: false)
                if parts.count == 2 {
                    let integerPart = parts[0]
                    let fraction = String(parts[1].prefix(2))
                    input = fraction.isEmpty ? String(integerPart) + "." : String(integerPart) + "." + fraction
                } else {
                    input = normalized
                }
            } else {
                input = normalized
            }
        }
    }
    
    private func formatDisplay() -> String {
        switch mode {
        case .integer:  String(Int(value))
        case .price:    String(format: "%.2f", value)
        case .decimal:  hasDecimalPoint ? String(format: "%.2f", value) : String(Int(value))
        }
    }
    
    private func confirmInput() {
        confirm?(value)
    }
    
    private static func formatInitialValue(_ value: Double, mode: NumberPadMode) -> String {
        switch mode {
        case .integer:  String(Int(value))
        case .price:    String(Int(value * 100))
        case .decimal:  String(format: "%g", value)
        }
    }
    
    private func canAddNumber(_ char: String) -> Bool {
        guard let maxDigits else { return true }
        
        if mode == .integer {
            return input.count <= maxDigits
        } else {
            return input.count <= maxDigits + 1
        }
    }    
}

#Preview {
    struct Preview: View {
        var body: some View {
            ScrollView {
                VStack(spacing: 20){
                    VStack{
                        Text("Integer mode")
                        NumberPadWrapper(mode: .integer, maxDigits: 5)
                    }
                    .padding()
                    .cornerRadius(8)
                    .border(.gray.opacity(0.2))
                    
                    VStack{
                        Text("Price Mode")
                        NumberPadWrapper(mode: .price)
                    }
                    .padding()
                    .cornerRadius(8)
                    .border(.gray.opacity(0.2))
                    
                    VStack{
                        Text("Decimal Mode")
                        NumberPadWrapper(mode: .decimal)
                    }
                    .padding()
                    .cornerRadius(8)
                    .border(.gray.opacity(0.2))
                    
                    VStack{
                        Text("With min and max values")
                        NumberPadWrapper(mode: .decimal, minValue:0, maxValue:10)
                    }
                    .padding()
                    .cornerRadius(8)
                    .border(.gray.opacity(0.2))
                    
                    VStack{
                        Text("With confirm action")
                        NumberPadWrapper(mode: .price, confirm: { value in
                            print("Tip entered: \(value)")
                        })
                    }
                    .padding()
                    .cornerRadius(8)
                    .border(.gray.opacity(0.2))
                }
            }
            .frame(maxWidth: 300)
        }
    }
    
    struct NumberPadWrapper: View {
        @State var value: Double = 0
        let mode: NumberPadMode
        let maxDigits: Int?
        let minValue: Double?
        let maxValue: Double?
        let confirm: ((Double)->Void)?
        
        init(mode: NumberPadMode = .integer, minValue:Double? = nil, maxValue:Double? = nil, maxDigits: Int? = nil, confirm: ((Double)->Void)? = nil) {
            self.mode = mode
            self.minValue = minValue
            self.maxValue = maxValue
            self.maxDigits = maxDigits
            self.confirm = confirm
        }
        
        var body: some View {
            NumberPadView(value: $value, mode: mode, minValue:minValue, maxValue:maxValue, maxDigits: maxDigits, confirm: confirm)
        }
    }
    return Preview()
}
