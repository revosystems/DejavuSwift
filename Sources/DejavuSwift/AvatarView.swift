import SwiftUI

public struct AvatarView : View {

    let url:URL?
    
    public init(url: URL?) {
        self.url = url
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
}


#Preview {
    AvatarView(
        url: URL("https://hws.dev/paul.jpg")
    )
}
