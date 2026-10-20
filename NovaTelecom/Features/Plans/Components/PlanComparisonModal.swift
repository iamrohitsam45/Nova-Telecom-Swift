import SwiftUI

public struct PlanComparisonModal: View {
    public let plans: [Plan]
    @Environment(\.dismiss) private var dismiss

    public init(plans: [Plan]) {
        self.plans = plans
    }

    public var body: some View {
        NavigationStack {
            ZStack {
                TelecomColors.backgroundGradient.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Plan Headers
                        HStack(alignment: .top, spacing: 12) {
                            ForEach(plans) { plan in
                                VStack(spacing: 6) {
                                    if plan.isPopular {
                                        StatusBadge(text: "POPULAR", type: .cyber)
                                    } else if plan.isBestValue {
                                        StatusBadge(text: "BEST VALUE", type: .active)
                                    }

                                    Text(plan.name)
                                        .font(TelecomTypography.titleSmall)
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)

                                    Text(plan.formattedPrice)
                                        .font(TelecomTypography.titleLarge)
                                        .foregroundColor(TelecomColors.neonCyan)

                                    Text("/ \(plan.validityDescription)")
                                        .font(TelecomTypography.captionSmall)
                                        .foregroundColor(TelecomColors.neutralMuted)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(12)
                                .background(TelecomColors.cardBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                        }

                        // Feature Comparison Table
                        GlassCard(cornerRadius: 20, padding: 16) {
                            VStack(spacing: 12) {
                                compRow(title: "Plan Type", values: plans.map { $0.type.displayName })
                                Divider().background(Color.white.opacity(0.1))

                                compRow(
                                    title: "Speed / Quota",
                                    values: plans.map {
                                        if let speed = $0.downloadSpeedMbps {
                                            return "\(DataSizeFormatter.formatSpeed(mbps: speed)) Symmetrical"
                                        } else if let quota = $0.dataQuotaGB {
                                            return "\(quota) GB Quota"
                                        } else {
                                            return "Unlimited 5G Data"
                                        }
                                    }
                                )
                                Divider().background(Color.white.opacity(0.1))

                                compRow(title: "Hardware", values: plans.map { $0.routerIncluded ? "Router Included" : "BYO / Extra" })
                                Divider().background(Color.white.opacity(0.1))

                                compRow(
                                    title: "Included Apps",
                                    values: plans.map { $0.bundledOTTApps.isEmpty ? "None" : $0.bundledOTTApps.joined(separator: ", ") }
                                )
                            }
                        }
                    }
                    .padding(16)
                }
            }
            .navigationTitle("Plan Comparison")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                        .foregroundColor(TelecomColors.neonCyan)
                }
            }
        }
    }

    private func compRow(title: String, values: [String]) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title.uppercased())
                .font(TelecomTypography.badge)
                .foregroundColor(TelecomColors.neutralMuted)

            HStack(spacing: 12) {
                ForEach(0..<values.count, id: \.self) { i in
                    Text(values[i])
                        .font(TelecomTypography.captionMedium)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}
