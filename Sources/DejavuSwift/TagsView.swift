import SwiftUI

public struct Tag {
    let icon:String?
    let text:String
    let color:Color?
    
    public init(icon:String?, text:String, color:Color?){
        self.icon = icon
        self.text = text
        self.color = color
    }
}

public struct TagsView : View {
    
    public var tags:[Tag]
    
    public init(tags:[Tag]){
        self.tags = tags
    }
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(tags, id: \.text) { tag in
                    HStack {
                        if let icon = tag.icon {
                            Image(systemName: icon)
                                .foregroundColor(.white)
                        }
                        Text(tag.text)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(tag.color ?? .gray)
                    .cornerRadius(8)
                }
            }
            .padding()
        }
    }
}


#Preview {
    TagsView(tags: [
        Tag(icon: "person.fill", text: "Patata 1", color: Color("Brand")),
        Tag(icon: "star.fill", text: "Patata 2", color: .red),
        Tag(icon: "leaf.fill", text: "Patata 3", color: .blue),
        Tag(icon: nil, text: "Patata 4", color: .green),
        Tag(icon: "flame.fill", text: "Patata 5", color: .orange)
    ])
}
