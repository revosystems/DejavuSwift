import SwiftUI

public struct ButtonPrimary : View {
    
    let icon:String?
    let title:String
    let action:()->Void
    
    public init(_ title:String, icon:String? = nil, action:@escaping()->Void){
        self.title = title
        self.icon = icon
        self.action = action
    }
    
    public var body: some View {
        Button(title) {
            action()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Dejavu.brand)
        .foregroundColor(.white)
        .cornerRadius(4)
    }
}


#Preview {
    ButtonPrimary("Press Me") {
        debugPrint("Pressed")
    }
}
