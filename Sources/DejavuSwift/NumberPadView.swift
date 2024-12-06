import SwiftUI

struct NumberPadView: View {
    @State private var input = "0" {
        didSet {
            value = Int(input) ?? 0
        }
    }
    @Binding var value:Int
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            // Display for entered number
            Text(input)
                .font(.largeTitle)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(4)
            
            // Number pad buttons
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(1...9, id: \.self) { number in
                    Button(action: {
                        addNumber(String(number))
                    }) {
                        Text("\(number)")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .frame(height:60)
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                    }
                }
                
                // Backspace button
                Button(action: {
                    removeNumber()
                }) {
                    Image(systemName: "delete.left")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .frame(height:60)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(4)
                }
                
                // Zero button
                Button(action: {
                    addNumber("0")
                }) {
                    Text("0")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .frame(height:60)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(4)
                }
                
                // Confirm button
                Button(action: {
                    confirmInput()
                }) {
                    Image(systemName: "checkmark")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .frame(height:60)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(4)
                }
                
            }
            .frame(maxWidth: .infinity)
            Spacer()
        }
        .padding()
    }
    
    private func addNumber(_ number: String) {
        if input == "0" {
            input = number
        } else {
            input += number
        }
    }
    
    private func removeNumber() {
        input = String(input.dropLast())
        if input.isEmpty {
            input = "0"
        }
    }
    
    private func confirmInput() {
        // Handle confirmation action here
    }
}

#Preview {
    NumberPadView(value: .constant(0))
}
