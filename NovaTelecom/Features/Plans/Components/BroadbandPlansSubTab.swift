import SwiftUI

public struct BroadbandPlansSubTab: View {
    public let plans: [Plan]
    public let onSelectPlan: (Plan) -> Void
    public let onCheckAvailabilityTapped: () -> Void

    public init(
        plans: [Plan],
        onSelectPlan: @escaping (Plan) -> Void,
        onCheckAvailabilityTapped: @escaping () -> Void
    ) {
        self.plans = plans.filter { $0.type == .broadbandFiber }
        self.onSelectPlan = onSelectPlan
        self.onCheckAvailabilityTapped = onCheckAvailabilityTapped
    }

    public var body: some View {
        VStack(spacing: 16) {
            // Address Coverage Checker Banner
            Button(action: {
                HapticFeedback.light()
                onCheckAvailabilityTapped()
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "location.magnifyingglass")
                        .font(.system(size: 24))
                        .foregroundColor(TelecomColors.neonCyan)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Check Fiber Availability at Your Address")
                            .font(TelecomTypography.bodyBold)
                            .foregroundColor(.white)
                        Text("Verify XGS-PON multi-gigabit readiness and instant dispatch")
                            .font(TelecomTypography.captionSmall)
                            .foregroundColor(TelecomColors.neutralMuted)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(TelecomColors.neonCyan)
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(TelecomColors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(TelecomColors.neonCyan.opacity(0.4), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 16)
            }
            .buttonStyle(ScaleBounceButtonStyle())

            // Fiber Plans List
            ForEach(plans) { plan in
                fiberPlanCard(plan)
            }
        }
        .padding(.top, 8)
    }

    private func fiberPlanCard(_ plan: Plan) -> some View {
        GlassCard(cornerRadius: 22, padding: 16, hasGlow: plan.isBestValue) {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("ULTRA FIBER OPTICAL")
                            .font(TelecomTypography.badge)
                            .foregroundColor(TelecomColors.neonCyan)
                        Text(plan.name)
                            .font(TelecomTypography.titleSmall)
                            .foregroundColor(.white)
                    }

                    Spacer()

                    if plan.isPopular {
                        StatusBadge(text: "POPULAR", type: .cyber)
                    } else if plan.isBestValue {
                        StatusBadge(text: "BEST VALUE", type: .active)
                    }
                }

                Text(plan.headline)
                    .font(TelecomTypography.bodyMedium)
                    .foregroundColor(TelecomColors.neutralMuted)

                // Speeds Readout Row
                HStack(spacing: 16) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.down.circle.fill")
                            .foregroundColor(TelecomColors.neonCyan)
                        VStack(alignment: .leading, spacing: 1) {
                            Text("DOWNLOAD")
                                .font(TelecomTypography.badge)
                                .foregroundColor(TelecomColors.neutralMuted)
                            Text(DataSizeFormatter.formatSpeed(mbps: plan.downloadSpeedMbps ?? 0))
                                .font(TelecomTypography.bodyBold)
                                .foregroundColor(.white)
                        }
                    }

                    Divider().frame(height: 24).background(Color.white.opacity(0.15))

                    HStack(spacing: 6) {
                        Image(systemName: "arrow.up.circle.fill")
                            .foregroundColor(TelecomColors.cyberViolet)
                        VStack(alignment: .leading, spacing: 1) {
                            Text("UPLOAD")
                                .font(TelecomTypography.badge)
                                .foregroundColor(TelecomColors.neutralMuted)
                            Text(DataSizeFormatter.formatSpeed(mbps: plan.uploadSpeedMbps ?? 0))
                                .font(TelecomTypography.bodyBold)
                                .foregroundColor(.white)
                        }
                    }

                    Spacer()

                    if plan.routerIncluded {
                        HStack(spacing: 4) {
                            Image(systemName: "wifi.router")
                            Text("Router Free")
                        }
                        .font(TelecomTypography.badge)
                        .foregroundColor(TelecomColors.successGreen)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(TelecomColors.successGreen.opacity(0.12))
                        .clipShape(Capsule())
                    }
                }
                .padding(10)
                .background(Color.white.opacity(0.04))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // Feature items
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
                    VStack(alignment: .leading, spacing: 6) {
                        Text("BUNDLED STREAMING SUBSCRIPTIONS")
                            .font(TelecomTypography.badge)
                            .foregroundColor(TelecomColors.neutralMuted)

                        HStack(spacing: 8) {
                            ForEach(plan.bundledOTTApps, id: \.self) { app in
                                Text(app)
                                    .font(TelecomTypography.captionSmall)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(TelecomColors.cyberViolet.opacity(0.25))
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }

                // Pricing and CTA
                HStack {
                    VStack(alignment: .leading, spacing: 1) {
                        Text(plan.formattedPrice)
                            .font(TelecomTypography.titleLarge)
                            .foregroundColor(TelecomColors.neonCyan)
                        Text("/ Month • Zero Contract Fee")
                            .font(TelecomTypography.captionSmall)
                            .foregroundColor(TelecomColors.neutralMuted)
                    }

                    Spacer()

                    TelecomButton(
                        title: "Choose Plan",
                        icon: "arrow.right",
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
