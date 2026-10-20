import SwiftUI

public struct StreamingPlansSubTab: View {
    public let plans: [Plan]
    public let onSelectPlan: (Plan) -> Void

    public init(plans: [Plan], onSelectPlan: @escaping (Plan) -> Void) {
        self.plans = plans.filter { $0.type == .streamingOTT }
        self.onSelectPlan = onSelectPlan
    }

    public var body: some View {
        VStack(spacing: 16) {
            ForEach(plans) { plan in
                ottCard(plan)
            }
        }
        .padding(.top, 8)
    }

    private func ottCard(_ plan: Plan) -> some View {
        GlassCard(cornerRadius: 20, padding: 16, hasGlow: plan.isPopular) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "play.tv.fill")
                        .foregroundColor(TelecomColors.cyberViolet)
                        .font(.system(size: 22))
                    VStack(alignment: .leading, spacing: 2) {
                        Text(plan.name)
                            .font(TelecomTypography.titleSmall)
                            .foregroundColor(.white)
                        Text(plan.headline)
                            .font(TelecomTypography.captionSmall)
                            .foregroundColor(TelecomColors.neutralMuted)
                    }
                    Spacer()
                    if plan.isPopular {
                        StatusBadge(text: "4K ULTRA HD", type: .cyber)
                    }
                }

                Divider().background(Color.white.opacity(0.1))

                ForEach(plan.features) { feat in
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(TelecomColors.successGreen)
                            .font(.system(size: 12))
                        Text(feat.title)
                            .font(TelecomTypography.captionMedium)
                            .foregroundColor(.white.opacity(0.9))
                    }
                }

                HStack {
                    VStack(alignment: .leading, spacing: 1) {
                        Text(plan.formattedPrice)
                            .font(TelecomTypography.titleLarge)
                            .foregroundColor(TelecomColors.neonCyan)
                        Text("Billed directly on telecom invoice")
                            .font(TelecomTypography.captionSmall)
                            .foregroundColor(TelecomColors.neutralMuted)
                    }

                    Spacer()

                    TelecomButton(
                        title: "Activate Now",
                        icon: "bolt.fill",
                        style: .primary,
                        isFullWidth: false,
                        action: { onSelectPlan(plan) }
                    )
                }
            }
        }
        .padding(.horizontal, 16)
    }
}
