import SwiftUI

public enum QuickActionType: String, CaseIterable, Identifiable {
    case recharge = "Recharge"
    case payBill = "Pay Bill"
    case upgradeSpeed = "Upgrade Speed"
    case buyModem = "Buy Modem"
    case manageSIM = "Manage SIM"

    public var id: String { rawValue }

    public var icon: String {
        switch self {
        case .recharge: return "bolt.fill"
        case .payBill: return "creditcard.fill"
        case .upgradeSpeed: return "arrow.up.forward.circle.fill"
        case .buyModem: return "wifi.router.fill"
        case .manageSIM: return "simcard.fill"
        }
    }

    public var color: Color {
        switch self {
        case .recharge: return TelecomColors.neonCyan
        case .payBill: return TelecomColors.successGreen
        case .upgradeSpeed: return TelecomColors.cyberViolet
        case .buyModem: return TelecomColors.electricBlue
        case .manageSIM: return TelecomColors.warningAmber
        }
    }
}

public struct QuickActionGrid: View {
    public let onSelectAction: (QuickActionType) -> Void

    public init(onSelectAction: @escaping (QuickActionType) -> Void) {
        self.onSelectAction = onSelectAction
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("QUICK ACTIONS")
                .font(TelecomTypography.captionMedium)
                .foregroundColor(TelecomColors.neutralMuted)
                .padding(.horizontal, 4)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(QuickActionType.allCases) { action in
                        Button(action: {
                            HapticFeedback.light()
                            onSelectAction(action)
                        }) {
                            VStack(spacing: 10) {
                                ZStack {
                                    Circle()
                                        .fill(action.color.opacity(0.18))
                                        .frame(width: 48, height: 48)

                                    Image(systemName: action.icon)
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(action.color)
                                }

                                Text(action.rawValue)
                                    .font(TelecomTypography.captionSmall)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                            }
                            .frame(width: 82, height: 96)
                            .background(TelecomColors.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                        }
                        .buttonStyle(ScaleBounceButtonStyle())
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
}
