import SwiftUI

public struct AvatarView : View {

    let url:URL?
    
    public init(url: URL?) {
        self.url = url
    }
    
    public var body: some View {
        if #available(iOS 15.0, *) {
            AsyncImage(url: url) {
                $0.image?.resizable()
            }
        } else {
            
        }
    }
}
