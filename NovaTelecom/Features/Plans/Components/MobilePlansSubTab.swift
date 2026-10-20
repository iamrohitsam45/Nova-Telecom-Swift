import SwiftUI

public struct MobilePlansSubTab: View {
    public let plans: [Plan]
    public let onSelectPlan: (Plan) -> Void

    @State private var planFilter: String = "ALL" // "ALL", "PREPAID", "POSTPAID"

    public init(plans: [Plan], onSelectPlan: @escaping (Plan) -> Void) {
        self.plans = plans
        self.onSelectPlan = onSelectPlan
    }

    private var filteredPlans: [Plan] {
        switch planFilter {
        case "PREPAID":
            return plans.filter { $0.type == .mobilePrepaid }
        case "POSTPAID":
            return plans.filter { $0.type == .mobilePostpaid }
        default:
            return plans.filter { $0.type == .mobilePrepaid || $0.type == .mobilePostpaid }
        }
    }

    public var body: some View {
        VStack(spacing: 16) {
            // Segment Filter
            Picker("Plan Type", selection: $planFilter) {
                Text("All Mobile").tag("ALL")
                Text("Prepaid 5G").tag("PREPAID")
                Text("Postpaid 5G").tag("POSTPAID")
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 16)

            // Plans List
            ForEach(filteredPlans) { plan in
                planCard(plan)
            }
        }
        .padding(.top, 8)
    }

    private func planCard(_ plan: Plan) -> some View {
        GlassCard(cornerRadius: 20, padding: 16, hasGlow: plan.isPopular) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(plan.type.displayName.uppercased())
                            .font(TelecomTypography.badge)
                            .foregroundColor(TelecomColors.neonCyan)
                        Text(plan.name)
                            .font(TelecomTypography.titleSmall)
                            .foregroundColor(.white)
                    }

                    Spacer()

                    if plan.isPopular {
                        StatusBadge(text: "MOST POPULAR", type: .cyber)
                    } else if plan.isBestValue {
                        StatusBadge(text: "BEST VALUE", type: .active)
                    }
                }

                Text(plan.headline)
                    .font(TelecomTypography.bodyMedium)
                    .foregroundColor(TelecomColors.neutralMuted)

                Divider().background(Color.white.opacity(0.1))

                // Quota & Validity Row
                HStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("5G DATA")
                            .font(TelecomTypography.badge)
                            .foregroundColor(TelecomColors.neutralMuted)
                        Text(plan.isUnlimitedData ? "Unlimited" : "\(String(format: "%.1f", plan.dataQuotaGB ?? 0)) GB")
                            .font(TelecomTypography.bodyBold)
                            .foregroundColor(.white)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text("VALIDITY")
                            .font(TelecomTypography.badge)
                            .foregroundColor(TelecomColors.neutralMuted)
                        Text(plan.validityDescription)
                            .font(TelecomTypography.bodyBold)
                            .foregroundColor(.white)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text("CALLS")
                            .font(TelecomTypography.badge)
                            .foregroundColor(TelecomColors.neutralMuted)
                        Text("Unlimited")
                            .font(TelecomTypography.bodyBold)
                            .foregroundColor(.white)
                    }
                }

                // Features bullets
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

                // Bundled OTT Apps
                if !plan.bundledOTTApps.isEmpty {
                    HStack(spacing: 6) {
                        Text("Included:")
                            .font(TelecomTypography.captionSmall)
                            .foregroundColor(TelecomColors.neutralMuted)
                        ForEach(plan.bundledOTTApps, id: \.self) { app in
                            Text(app)
                                .font(TelecomTypography.badge)
                                .foregroundColor(TelecomColors.cyberViolet)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(TelecomColors.cyberViolet.opacity(0.15))
                                .clipShape(Capsule())
                        }
                    }
                }

                // Price and Select Action
                HStack {
                    VStack(alignment: .leading, spacing: 1) {
                        Text(plan.formattedPrice)
                            .font(TelecomTypography.titleLarge)
                            .foregroundColor(TelecomColors.neonCyan)
                        Text("Taxes & eSIM Included")
                            .font(TelecomTypography.captionSmall)
                            .foregroundColor(TelecomColors.neutralMuted)
                    }

                    Spacer()

                    TelecomButton(
                        title: "Select & Recharge",
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
