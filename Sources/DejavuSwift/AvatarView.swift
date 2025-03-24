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
                case .empty:
                    ProgressView()
                case .success(let image):
                    image.resizable()
                case .failure:
                    Dejavu.image("default-avatar")
                @unknown default:
                    // Since the AsyncImagePhase enum isn't frozen,
                    // we need to add this currently unused fallback
                    // to handle any new cases that might be added
                    // in the future:
                    EmptyView()
                }
            }
        }
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
        )
        AvatarView(
            gravatar: "jordi@gloobus.net", size:200
        )
    }
}
