import SwiftUI

public struct DTHPlansSubTab: View {
    public let plans: [Plan]
    public let onSelectPlan: (Plan) -> Void

    public init(plans: [Plan], onSelectPlan: @escaping (Plan) -> Void) {
        self.plans = plans.filter { $0.type == .dthTelevision }
        self.onSelectPlan = onSelectPlan
    }

    public var body: some View {
        VStack(spacing: 16) {
            ForEach(plans) { plan in
                dthCard(plan)
            }
        }
        .padding(.top, 8)
    }

    private func dthCard(_ plan: Plan) -> some View {
        GlassCard(cornerRadius: 20, padding: 16, hasGlow: plan.isPopular) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "tv.inset.filled")
                        .foregroundColor(TelecomColors.cyberViolet)
                        .font(.system(size: 20))
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
                        StatusBadge(text: "POPULAR", type: .cyber)
                    }
                }

                HStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("TOTAL CHANNELS")
                            .font(TelecomTypography.badge)
                            .foregroundColor(TelecomColors.neutralMuted)
                        Text("\(plan.dthChannelCount ?? 0)+")
                            .font(TelecomTypography.titleMedium)
                            .foregroundColor(.white)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text("4K / HD CHANNELS")
                            .font(TelecomTypography.badge)
                            .foregroundColor(TelecomColors.neutralMuted)
                        Text("\(plan.hdChannelCount ?? 0) HD")
                            .font(TelecomTypography.titleMedium)
                            .foregroundColor(TelecomColors.neonCyan)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text("VALIDITY")
                            .font(TelecomTypography.badge)
                            .foregroundColor(TelecomColors.neutralMuted)
                        Text(plan.validityDescription)
                            .font(TelecomTypography.titleMedium)
                            .foregroundColor(.white)
                    }
                }
                .padding(10)
                .background(Color.white.opacity(0.04))
                .clipShape(RoundedRectangle(cornerRadius: 12))

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
                    Text(plan.formattedPrice)
                        .font(TelecomTypography.titleLarge)
                        .foregroundColor(TelecomColors.neonCyan)
                    Text("/ Month")
                        .font(TelecomTypography.captionSmall)
                        .foregroundColor(TelecomColors.neutralMuted)

                    Spacer()

                    TelecomButton(
                        title: "Subscribe Pack",
                        icon: "tv.fill",
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
