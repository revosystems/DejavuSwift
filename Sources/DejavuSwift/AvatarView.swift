import SwiftUI

public struct AvatarView : View {

    let url:URL?
    let fallback:URL?
    
    public init(url: URL?, fallback:URL? = nil) {
        self.url = url
        self.fallback = fallback
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
                    if let fallback {
                        AsyncImage(url: fallback) {
                            $0.image?.resizable()
                        }
                    }
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
        url: URL("https://hws.dev/paul.jpg"),
        fallback: URL("https://raw.githubusercontent.com/BadChoice/handesk/dev/public/images/default-avatar.png")
    )
}
