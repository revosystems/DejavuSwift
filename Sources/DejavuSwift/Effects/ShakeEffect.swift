import SwiftUI
import Foundation

public struct ShakeEffect: GeometryEffect {
    public var animatableData: CGFloat

    public func effectValue(size: CGSize) -> ProjectionTransform {
        let translation = 10 * sin(animatableData * .pi * 4)
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
    }
}
