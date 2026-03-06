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
                ForEach(tags, id: \.text) {
                    TagView($0)
                }
            }
        }
    }
}

public struct TagView: View {
    public let tag:Tag
    
    public init(_ tag:Tag){
        self.tag = tag
    }
    
    public var body: some View {
        HStack {
            if let icon = tag.icon {
                Image(systemName: icon)
                    
            }
            if let image = tag.image {
                image
                    .resizable()
                    .frame(width: 18, height: 18)
            }
            Text(tag.text)
        }
        .foregroundColor(tag.foregroundColor)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(tag.color ?? .gray)
        .cornerRadius(8)
    }
}


#Preview {
    VStack(spacing: 20) {
        TagsView(tags: [
            Tag(text: "Label", color: .blue),
            Tag(text: "Category", color: .green),
            Tag(text: "Tag", color: .orange)
        ])
        
        TagsView(tags: [
            Tag(icon: "person.fill", text: "User", color: Dejavu.brand),
            Tag(icon: "star.fill", text: "Favorite", color: .red),
            Tag(icon: "leaf.fill", text: "Eco", color: .green)
        ])
        
        TagsView(tags: [
            Tag(image: Dejavu.image("allergens-1"), text: "Allergen", color: .purple),
            Tag(image: Image(systemName: "person.fill"), text: "Custom", color: .green)
        ])
        
        TagsView(tags: [
            Tag(text: "Light Tag", color: .yellow, foregroundColor: .black),
            Tag(text: "Dark Tag", color: .gray, foregroundColor: .white)
        ])
        
        HStack {
            TagView(Tag(icon: "star.fill", text: "Featured", color: .yellow))
            TagView(Tag(text: "New", color: .green))
        }
        
        TagsView(tags: [
            Tag(image: Dejavu.image("allergens-8"), text: "Peanuts", color: Dejavu.backgroundDarker, foregroundColor: Dejavu.textPrimary),
            Tag(image: Dejavu.image("allergens-14"), text: "Gluten", color: Dejavu.backgroundDarker, foregroundColor: Dejavu.textPrimary),
            Tag(image: Dejavu.image("allergens-13"), text: "Dairy", color: Dejavu.backgroundDarker, foregroundColor: Dejavu.textPrimary)
        ])
    }
    .padding()
}
