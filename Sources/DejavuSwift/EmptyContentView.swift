import SwiftUI

public struct EmptyContentView<AdditionalContent: View>: View {
    let icon: String?
    let text: String?
    let additionalText: String?
    @ViewBuilder let additionalContent: AdditionalContent
    
    public init(
        icon: String?,
        text: String?,
        additionalText: String? = nil,
        @ViewBuilder additionalContent: () -> AdditionalContent
    ) {
        self.icon = icon
        self.text = text
        self.additionalText = additionalText
        self.additionalContent = additionalContent()
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 60))
                    .foregroundColor(Color(UIColor.systemGray))
            }
            
            if let additionalText {
                Text(additionalText)
                    .font(.system(size: 15))
                    .foregroundColor(Color(UIColor.secondaryLabel))
            }
            
            if let text {
                Group {
                    if #available(iOS 17.0, *) {
                        Text(text)
                            .containerRelativeFrame(.horizontal) { size, axis in
                                size * 0.6
                            }
                    } else {
                        Text(text)
                    }
                }
                .font(.system(size: 15))
                .foregroundColor(Color(UIColor.systemGray))
            }
            
            additionalContent
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
