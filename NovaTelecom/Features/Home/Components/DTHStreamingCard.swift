import SwiftUI

public struct DTHStreamingCard: View {
    public let dthAccount: DTHAccount
    public let subscriptions: [StreamingSubscription]
    public let onManageTapped: () -> Void

    public init(
        dthAccount: DTHAccount,
        subscriptions: [StreamingSubscription],
        onManageTapped: @escaping () -> Void
    ) {
        self.dthAccount = dthAccount
        self.subscriptions = subscriptions
        self.onManageTapped = onManageTapped
    }

    public var body: some View {
        GlassCard(cornerRadius: 20, padding: 16) {
            VStack(alignment: .leading, spacing: 14) {
                // DTH Row
                HStack {
                    Image(systemName: "tv.inset.filled")
                        .foregroundColor(TelecomColors.cyberViolet)
                        .font(.system(size: 20))

                    VStack(alignment: .leading, spacing: 2) {
                        Text(dthAccount.packageName)
                            .font(TelecomTypography.titleSmall)
                            .foregroundColor(.white)
                        Text("\(dthAccount.totalChannels) Live Channels • Smart Card: \(dthAccount.smartCardNumber)")
                            .font(TelecomTypography.captionSmall)
                            .foregroundColor(TelecomColors.neutralMuted)
                    }

                    Spacer()

                    StatusBadge(text: "ACTIVE", type: .active)
                }

                Divider()
                    .background(Color.white.opacity(0.12))

                // Streaming Row
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("ACTIVE STREAMING SUBSCRIPTIONS")
                            .font(TelecomTypography.captionSmall)
                            .foregroundColor(TelecomColors.neutralMuted)
                        Spacer()
                        Button(action: onManageTapped) {
                            Text("Manage")
                                .font(TelecomTypography.captionSmall)
                                .foregroundColor(TelecomColors.neonCyan)
                        }
                    }

                    HStack(spacing: 8) {
                        ForEach(subscriptions) { sub in
                            HStack(spacing: 6) {
                                Image(systemName: sub.iconUrl)
                                    .font(.system(size: 13))
                                    .foregroundColor(sub.isActivated ? TelecomColors.neonCyan : TelecomColors.neutralMuted)
                                Text(sub.providerName)
                                    .font(TelecomTypography.captionSmall)
                                    .foregroundColor(sub.isActivated ? .white : TelecomColors.neutralMuted)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.06))
                            .clipShape(Capsule())
                        }
                    }
                }
            }
        }
    }
}
