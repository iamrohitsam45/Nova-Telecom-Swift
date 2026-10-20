import SwiftUI

public struct RecommendedOffersView: View {
    public let onSelectOffer: (String) -> Void

    public init(onSelectOffer: @escaping (String) -> Void) {
        self.onSelectOffer = onSelectOffer
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("SPECIAL OFFERS FOR YOU")
                .font(TelecomTypography.captionMedium)
                .foregroundColor(TelecomColors.neutralMuted)
                .padding(.horizontal, 4)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    OfferView(
                        tag: "FIBER UPGRADE",
                        title: "Upgrade to 2.5 Gbps",
                        subtitle: "Get free Mesh Satellite Node + 3 months Netflix 4K",
                        gradient: LinearGradient(colors: [TelecomColors.electricBlue, TelecomColors.cyberViolet], startPoint: .topLeading, endPoint: .bottomTrailing),
                        onTap: { onSelectOffer("fiber_upgrade_offer") }
                    )

                    OfferView(
                        tag: "5G ANNUAL",
                        title: "Save $40 on Annual 5G",
                        subtitle: "Unlimited high-speed data + Prime Video included all year",
                        gradient: LinearGradient(colors: [TelecomColors.neonCyan.opacity(0.8), TelecomColors.electricBlue], startPoint: .topLeading, endPoint: .bottomTrailing),
                        onTap: { onSelectOffer("annual_5g_offer") }
                    )
                }
                .padding(.horizontal, 4)
            }
        }
    }
}

private struct OfferView: View {
    let tag: String
    let title: String
    let subtitle: String
    let gradient: LinearGradient
    let onTap: () -> Void

    var body: some View {
        Button(action: {
            HapticFeedback.light()
            onTap()
        }) {
            VStack(alignment: .leading, spacing: 8) {
                Text(tag)
                    .font(TelecomTypography.badge)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.black.opacity(0.3))
                    .clipShape(Capsule())

                Text(title)
                    .font(TelecomTypography.titleSmall)
                    .foregroundColor(.white)

                Text(subtitle)
                    .font(TelecomTypography.captionSmall)
                    .foregroundColor(.white.opacity(0.85))
                    .lineLimit(2)
            }
            .padding(16)
            .frame(width: 240, height: 120, alignment: .topLeading)
            .background(gradient)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: Color.black.opacity(0.25), radius: 8, x: 0, y: 3)
        }
        .buttonStyle(ScaleBounceButtonStyle())
    }
}
