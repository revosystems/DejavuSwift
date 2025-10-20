import SwiftUI
import CryptoKit
import Foundation

public struct AvatarView : View {

    let url:URL?
    
    public init(url: URL?) {
        self.url = url
    }
    
    public init(gravatar email:String?, size:Int? = nil, defaultImage:String? = nil){
        self.url = Self.gravatar(email: email, size: size, defaultImage: defaultImage)
    }
    
    public var body: some View {
        if #available(iOS 15.0, *) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty: defaultAvatar
                case .success(let image): image.resizable()
                case .failure: defaultAvatar
                @unknown default:  defaultAvatar    // For possible future changes in AsyncImage
                }
            }
        }
    }
    
    var defaultAvatar: some View {
        Dejavu.image("default-avatar")?
            .resizable()
    }
    
    public static func gravatar(email:String?, size:Int? = nil, defaultImage:String? = nil) -> URL?{
        guard let email else {
            return nil
        }
        
        var params:[String] = []
        
        if let size = size {
            params.append("s=\(size)")
        }
        
        if let defaultImage = defaultImage {
            params.append("d=\(defaultImage)")
        }
        
        let data = email.replacingOccurrences(of: " ", with: "").lowercased().data(using: .utf8)!
        let hash = Insecure.MD5.hash(data: data).map { String(format: "%02hhx", $0) }.joined()
        let url = "https://www.gravatar.com/avatar/\(hash)?\(params.joined(separator: "&"))"
        return URL(string: url)
    }
}


#Preview {
    VStack{
        AvatarView(
            url: URL(string:"https://hws.dev/paul.jpg")
        ).frame(width: 50, height:50)
        
        AvatarView(
            gravatar: "jordi@gloobus.net", size:200
        ).frame(width: 50, height:50)
        
        AvatarView(
            gravatar: nil, size:200
        ).frame(width: 50, height:50)
    }.padding(8)
}
