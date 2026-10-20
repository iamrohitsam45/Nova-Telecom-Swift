import SwiftUI

public struct GlassCard<Content: View>: View {
    private let content: Content
    private let cornerRadius: CGFloat
    private let padding: CGFloat
    private let hasGlow: Bool

    public init(
        cornerRadius: CGFloat = 20,
        padding: CGFloat = 16,
        hasGlow: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.hasGlow = hasGlow
        self.content = content()
    }

    public var body: some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(TelecomColors.cardGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .stroke(
                                hasGlow
                                ? LinearGradient(colors: [TelecomColors.neonCyan.opacity(0.8), TelecomColors.electricBlue.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
                                : LinearGradient(colors: [Color.white.opacity(0.15), Color.white.opacity(0.02)], startPoint: .topLeading, endPoint: .bottomTrailing),
                                lineWidth: hasGlow ? 1.5 : 1
                            )
                    )
                    .shadow(color: hasGlow ? TelecomColors.neonCyan.opacity(0.2) : TelecomColors.glassShadow, radius: hasGlow ? 12 : 8, x: 0, y: 4)
            )
    }
}
