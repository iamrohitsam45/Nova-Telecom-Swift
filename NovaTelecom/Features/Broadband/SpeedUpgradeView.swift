import SwiftUI

public struct SpeedTierOption: Identifiable {
    public let id: String
    public let name: String
    public let downloadMbps: Int
    public let uploadMbps: Int
    public let priceMinorUnits: Int
    public let features: [String]
}

public struct SpeedUpgradeView: View {
    @Environment(\.dismiss) private var dismiss
    public let onUpgradeSuccess: (Int, Int, String) -> Void

    @State private var selectedTierId: String = "tier_2500"
    @State private var isProvisioning: Bool = false
    @State private var isCompleted: Bool = false

    private let tiers: [SpeedTierOption] = [
        SpeedTierOption(
            id: "tier_1000",
            name: "Nova Gigabit Pro 1000",
            downloadMbps: 1000,
            uploadMbps: 1000,
            priceMinorUnits: 7999,
            features: ["Symmetrical 1 Gbps", "Wi-Fi 7 Gateway", "Netflix 4K included"]
        ),
        SpeedTierOption(
            id: "tier_2500",
            name: "Nova Fiber Extreme 2.5 Gbps",
            downloadMbps: 2500,
            uploadMbps: 2500,
            priceMinorUnits: 12999,
            features: ["Symmetrical 2.5 Gbps", "Sub-2ms Gaming Core", "Dual Mesh 7 Nodes Included"]
        ),
        SpeedTierOption(
            id: "tier_5000",
            name: "Nova HyperFiber Ultra 5 Gbps",
            downloadMbps: 5000,
            uploadMbps: 5000,
            priceMinorUnits: 17999,
            features: ["5 Gbps Direct XGS-PON", "Static IPv4 & IPv6", "VIP 24/7 Field Priority"]
        )
    ]

    public init(onUpgradeSuccess: @escaping (Int, Int, String) -> Void) {
        self.onUpgradeSuccess = onUpgradeSuccess
    }

    public var body: some View {
        NavigationStack {
            ZStack {
                TelecomColors.backgroundGradient.ignoresSafeArea()

                if isCompleted {
                    provisionedSuccessView
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            Text("Upgrade Your Optical Line Speed")
                                .font(TelecomTypography.titleLarge)
                                .foregroundColor(.white)

                            Text("Digital speed upgrades are provisioned at the central Optical Line Terminal (OLT) within minutes. No technician visit required.")
                                .font(TelecomTypography.bodyMedium)
                                .foregroundColor(TelecomColors.neutralMuted)

                            ForEach(tiers) { tier in
                                let isSelected = selectedTierId == tier.id

                                Button(action: {
                                    HapticFeedback.selection()
                                    selectedTierId = tier.id
                                }) {
                                    GlassCard(cornerRadius: 20, padding: 16, hasGlow: isSelected) {
                                        VStack(alignment: .leading, spacing: 10) {
                                            HStack {
                                                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                                    .foregroundColor(isSelected ? TelecomColors.neonCyan : TelecomColors.neutralMuted)
                                                Text(tier.name)
                                                    .font(TelecomTypography.titleSmall)
                                                    .foregroundColor(.white)
                                                Spacer()
                                                Text("\(CurrencyFormatter.format(minorUnits: tier.priceMinorUnits))/mo")
                                                    .font(TelecomTypography.bodyBold)
                                                    .foregroundColor(TelecomColors.neonCyan)
                                            }

                                            HStack(spacing: 16) {
                                                HStack(spacing: 4) {
                                                    Image(systemName: "arrow.down.circle.fill")
                                                        .foregroundColor(TelecomColors.neonCyan)
                                                    Text(DataSizeFormatter.formatSpeed(mbps: tier.downloadMbps))
                                                        .font(TelecomTypography.bodyBold)
                                                        .foregroundColor(.white)
                                                }
                                                HStack(spacing: 4) {
                                                    Image(systemName: "arrow.up.circle.fill")
                                                        .foregroundColor(TelecomColors.cyberViolet)
                                                    Text(DataSizeFormatter.formatSpeed(mbps: tier.uploadMbps))
                                                        .font(TelecomTypography.bodyBold)
                                                        .foregroundColor(.white)
                                                }
                                            }

                                            ForEach(tier.features, id: \.self) { f in
                                                HStack(spacing: 6) {
                                                    Image(systemName: "checkmark")
                                                        .foregroundColor(TelecomColors.successGreen)
                                                        .font(.system(size: 11, weight: .bold))
                                                    Text(f)
                                                        .font(TelecomTypography.captionSmall)
                                                        .foregroundColor(.white.opacity(0.85))
                                                }
                                            }
                                        }
                                    }
                                }
                                .buttonStyle(ScaleBounceButtonStyle())
                            }

                            TelecomButton(
                                title: "Provision Speed Upgrade",
                                icon: "bolt.fill",
                                style: .primary,
                                isLoading: isProvisioning,
                                action: executeUpgrade
                            )
                        }
                        .padding(16)
                    }
                }
            }
            .navigationTitle("Speed Upgrade")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                        .foregroundColor(TelecomColors.neonCyan)
                }
            }
        }
    }

    private var provisionedSuccessView: some View {
        VStack(spacing: 20) {
            Spacer()

            ZStack {
                Circle()
                    .fill(TelecomColors.successGreen.opacity(0.18))
                    .frame(width: 80, height: 80)
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 56))
                    .foregroundColor(TelecomColors.successGreen)
            }

            Text("Speed Upgrade Provisioned!")
                .font(TelecomTypography.titleLarge)
                .foregroundColor(.white)

            Text("Your optical fiber terminal has updated profile rate limits. Your router will now deliver multi-gigabit symmetrical throughput.")
                .font(TelecomTypography.bodyMedium)
                .foregroundColor(TelecomColors.neutralMuted)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 28)

            Spacer()

            TelecomButton(
                title: "Return to Dashboard",
                icon: "arrow.right",
                style: .primary,
                action: { dismiss() }
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
    }

    private func executeUpgrade() {
        guard let tier = tiers.first(where: { $0.id == selectedTierId }) else { return }
        isProvisioning = true
        HapticFeedback.medium()

        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            DemoDataStore.shared.upgradeBroadbandSpeed(
                newDownloadMbps: tier.downloadMbps,
                newUploadMbps: tier.uploadMbps,
                planName: tier.name
            )
            onUpgradeSuccess(tier.downloadMbps, tier.uploadMbps, tier.name)
            isProvisioning = false
            isCompleted = true
            HapticFeedback.success()
        }
    }
}
