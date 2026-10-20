import SwiftUI

public struct MobileSimCard: View {
    public let simCard: SIMCard
    public let onRechargeTapped: () -> Void

    public init(simCard: SIMCard, onRechargeTapped: @escaping () -> Void) {
        self.simCard = simCard
        self.onRechargeTapped = onRechargeTapped
    }

    public var body: some View {
        GlassCard(cornerRadius: 20, padding: 16) {
            VStack(spacing: 14) {
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: simCard.isEsim ? "esim.fill" : "simcard.fill")
                            .foregroundColor(TelecomColors.electricBlue)
                            .font(.system(size: 18))
                        VStack(alignment: .leading, spacing: 2) {
                            Text(simCard.phoneNumber)
                                .font(TelecomTypography.titleSmall)
                                .foregroundColor(.white)
                            Text(simCard.planName)
                                .font(TelecomTypography.captionSmall)
                                .foregroundColor(TelecomColors.neutralMuted)
                        }
                    }

                    Spacer()

                    StatusBadge(text: "5G ULTRA", type: .cyber)
                }

                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("DATA REMAINING")
                            .font(TelecomTypography.captionSmall)
                            .foregroundColor(TelecomColors.neutralMuted)
                        Text("\(String(format: "%.1f", simCard.dataRemainingGB)) GB")
                            .font(TelecomTypography.titleMedium)
                            .foregroundColor(.white)
                    }

                    Spacer()

                    VStack(alignment: .leading, spacing: 2) {
                        Text("BALANCE")
                            .font(TelecomTypography.captionSmall)
                            .foregroundColor(TelecomColors.neutralMuted)
                        Text(simCard.formattedBalance)
                            .font(TelecomTypography.titleMedium)
                            .foregroundColor(TelecomColors.successGreen)
                    }

                    Spacer()

                    Button(action: {
                        HapticFeedback.light()
                        onRechargeTapped()
                    }) {
                        Text("Recharge")
                            .font(TelecomTypography.captionMedium)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(TelecomColors.heroGradient)
                            .clipShape(Capsule())
                    }
                }
            }
        }
    }
}
