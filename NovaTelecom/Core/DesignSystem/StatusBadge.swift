import SwiftUI

public enum StatusBadgeType {
    case active
    case pending
    case warning
    case error
    case info
    case cyber

    var color: Color {
        switch self {
        case .active: return TelecomColors.successGreen
        case .pending: return TelecomColors.warningAmber
        case .warning: return TelecomColors.warningAmber
        case .error: return TelecomColors.dangerRed
        case .info: return TelecomColors.electricBlue
        case .cyber: return TelecomColors.neonCyan
        }
    }

    var icon: String {
        switch self {
        case .active: return "checkmark.circle.fill"
        case .pending: return "clock.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.circle.fill"
        case .info: return "info.circle.fill"
        case .cyber: return "bolt.fill"
        }
    }
}

public struct StatusBadge: View {
    public let text: String
    public let type: StatusBadgeType
    public let showIcon: Bool

    public init(text: String, type: StatusBadgeType = .active, showIcon: Bool = true) {
        self.text = text
        self.type = type
        self.showIcon = showIcon
    }

    public var body: some View {
        HStack(spacing: 5) {
            if showIcon {
                Image(systemName: type.icon)
                    .font(.system(size: 10, weight: .bold))
            }
            Text(text)
                .font(TelecomTypography.badge)
        }
        .foregroundColor(type.color)
        .padding(.horizontal, 9)
        .padding(.vertical, 4)
        .background(type.color.opacity(0.16))
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(type.color.opacity(0.4), lineWidth: 0.8)
        )
    }
}
