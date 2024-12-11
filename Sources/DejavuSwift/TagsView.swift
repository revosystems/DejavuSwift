import SwiftUI

public struct Tag {
    let icon:String?
    let image:Image?
    let text:String
    let color:Color?
    let foregroundColor:Color
    
    public init(icon:String? = nil, image:Image? = nil, text:String, color:Color?, foregroundColor:Color = .white){
        self.icon = icon
        self.image = image
        self.text = text
        self.color = color
        self.foregroundColor = foregroundColor
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
                                .foregroundColor(tag.foregroundColor)
                        }
                        if let image = tag.image {
                            image
                                .resizable()
                                .foregroundColor(tag.foregroundColor)
                                .frame(width: 20, height: 20)
                        }
                        Text(tag.text)
                            .foregroundColor(tag.foregroundColor)
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
        Tag(image: Dejavu.image("allergens-1"), text: "Allergen", color:.purple),
        Tag(icon: "person.fill", text: "Patata 1", color: Dejavu.brand),
        Tag(icon: "star.fill", text: "Patata 2", color: .red),
        Tag(icon: "leaf.fill", text: "Patata 3", color: .blue),
        Tag(text: "Patata 4", color: .green, foregroundColor: .black),
        Tag(image: Image(systemName: "person.fill"), text: "Patata 4.1", color: .green, foregroundColor: .black),
        Tag(icon: "flame.fill", text: "Patata 5", color: .orange),
        
    ])
}
