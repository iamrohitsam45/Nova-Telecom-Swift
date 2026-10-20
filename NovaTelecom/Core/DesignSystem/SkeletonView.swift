import SwiftUI

public struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = -1.0

    public func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.0),
                            Color.white.opacity(0.18),
                            Color.white.opacity(0.0)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geo.size.width * 1.5)
                    .offset(x: phase * geo.size.width * 1.5)
                }
            )
            .mask(content)
            .onAppear {
                withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 1.0
                }
            }
    }
}

public extension View {
    func shimmering() -> some View {
        modifier(ShimmerModifier())
    }
}

public struct SkeletonBox: View {
    public let width: CGFloat?
    public let height: CGFloat
    public let cornerRadius: CGFloat

    public init(width: CGFloat? = nil, height: CGFloat = 16, cornerRadius: CGFloat = 6) {
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
    }

    public var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(Color.white.opacity(0.08))
            .frame(width: width, height: height)
            .shimmering()
    }
}
