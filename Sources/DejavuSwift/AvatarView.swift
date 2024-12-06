import SwiftUI

public struct AvatarView : View {

    let url:URL?
    
    public init(url: URL?) {
        self.url = url
    }
    
    public var body: some View {
        AsyncImage(url: url) {
            $0.image?.resizable()
        }
    }
}
