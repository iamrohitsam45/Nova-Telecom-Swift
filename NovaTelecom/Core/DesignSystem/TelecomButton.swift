import SwiftUI

public enum TelecomButtonStyle {
    case primary
    case secondary
    case cyanGlow
    case destructive
    case outline
}

public struct TelecomButton: View {
    public let title: String
    public let icon: String?
    public let style: TelecomButtonStyle
    public let isLoading: Bool
    public let isFullWidth: Bool
    public let action: () -> Void

    public init(
        title: String,
        icon: String? = nil,
        style: TelecomButtonStyle = .primary,
        isLoading: Bool = false,
        isFullWidth: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.isLoading = isLoading
        self.isFullWidth = isFullWidth
        self.action = action
    }

    public var body: some View {
        Button(action: {
            HapticFeedback.light()
            action()
        }) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.9)
                } else if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                }

                Text(title)
                    .font(TelecomTypography.bodyBold)
                    .lineLimit(1)
            }
            .foregroundColor(.white)
            .padding(.vertical, 14)
            .padding(.horizontal, 20)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .background(backgroundView)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(borderOverlay)
            .shadow(color: shadowColor, radius: 8, x: 0, y: 3)
        }
        .buttonStyle(ScaleBounceButtonStyle())
        .disabled(isLoading)
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .primary:
            TelecomColors.heroGradient
        case .secondary:
            Color.white.opacity(0.12)
        case .cyanGlow:
            TelecomColors.cyanGlowGradient
        case .destructive:
            TelecomColors.dangerRed
        case .outline:
            Color.clear
        }
    }

    @ViewBuilder
    private var borderOverlay: some View {
        switch style {
        case .outline:
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(TelecomColors.electricBlue, lineWidth: 1.5)
        case .cyanGlow:
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(TelecomColors.neonCyan.opacity(0.6), lineWidth: 1)
        default:
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.white.opacity(0.15), lineWidth: 0.8)
        }
    }

    private var shadowColor: Color {
        switch style {
        case .primary:
            return TelecomColors.electricBlue.opacity(0.35)
        case .cyanGlow:
            return TelecomColors.neonCyan.opacity(0.35)
        case .destructive:
            return TelecomColors.dangerRed.opacity(0.35)
        default:
            return Color.black.opacity(0.2)
        }
    }
}

public struct ScaleBounceButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.65), value: configuration.isPressed)
    }
}
