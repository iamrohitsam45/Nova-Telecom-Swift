import SwiftUI

public struct BroadbandStatusCard: View {
    public let connection: BroadbandConnection
    public let onUpgradeTapped: () -> Void
    public let onCardTapped: () -> Void

    public init(
        connection: BroadbandConnection,
        onUpgradeTapped: @escaping () -> Void,
        onCardTapped: @escaping () -> Void
    ) {
        self.connection = connection
        self.onUpgradeTapped = onUpgradeTapped
        self.onCardTapped = onCardTapped
    }

    public var body: some View {
        Button(action: onCardTapped) {
            GlassCard(cornerRadius: 22, padding: 18, hasGlow: connection.isOnline) {
                VStack(spacing: 16) {
                    // Header Row
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 6) {
                                Image(systemName: "bolt.horizontal.fill")
                                    .foregroundColor(TelecomColors.neonCyan)
                                Text(connection.planName)
                                    .font(TelecomTypography.titleSmall)
                                    .foregroundColor(.white)
                            }

                            Text("\(connection.serviceIdentifier) • \(connection.wifiSsid)")
                                .font(TelecomTypography.captionSmall)
                                .foregroundColor(TelecomColors.neutralMuted)
                        }

                        Spacer()

                        StatusBadge(
                            text: connection.isOnline ? "ONLINE" : "OFFLINE",
                            type: connection.isOnline ? .active : .error
                        )
                    }

                    // Speed Readout Grid
                    HStack(spacing: 16) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.down.circle.fill")
                                .foregroundColor(TelecomColors.neonCyan)
                                .font(.system(size: 18))
                            VStack(alignment: .leading, spacing: 2) {
                                Text("DOWNLOAD")
                                    .font(TelecomTypography.captionSmall)
                                    .foregroundColor(TelecomColors.neutralMuted)
                                Text(DataSizeFormatter.formatSpeed(mbps: connection.downloadSpeedMbps))
                                    .font(TelecomTypography.bodyBold)
                                    .foregroundColor(.white)
                            }
                        }

                        Divider()
                            .frame(height: 28)
                            .background(Color.white.opacity(0.15))

                        HStack(spacing: 8) {
                            Image(systemName: "arrow.up.circle.fill")
                                .foregroundColor(TelecomColors.cyberViolet)
                                .font(.system(size: 18))
                            VStack(alignment: .leading, spacing: 2) {
                                Text("UPLOAD")
                                    .font(TelecomTypography.captionSmall)
                                    .foregroundColor(TelecomColors.neutralMuted)
                                Text(DataSizeFormatter.formatSpeed(mbps: connection.uploadSpeedMbps))
                                    .font(TelecomTypography.bodyBold)
                                    .foregroundColor(.white)
                            }
                        }

                        Spacer()

                        Button(action: onUpgradeTapped) {
                            HStack(spacing: 4) {
                                Text("Upgrade")
                                    .font(TelecomTypography.captionSmall)
                                    .fontWeight(.bold)
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 10, weight: .bold))
                            }
                            .foregroundColor(TelecomColors.neonCyan)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(TelecomColors.neonCyan.opacity(0.14))
                            .clipShape(Capsule())
                        }
                    }
                    .padding(12)
                    .background(Color.white.opacity(0.04))
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                    // Circular Data Usage Gauge
                    DataUsageGauge(
                        usedGB: connection.dataUsedGB,
                        totalGB: connection.dataTotalGB,
                        unit: "GB",
                        title: "HIGH-SPEED DATA QUOTA",
                        subtitle: "Next bill \(connection.formattedNextBill) due in 12 days"
                    )
                }
            }
        }
        .buttonStyle(ScaleBounceButtonStyle())
    }
}
