import SwiftUI

public struct DataUsageGauge: View {
    public let usedGB: Double
    public let totalGB: Double
    public let unit: String
    public let title: String
    public let subtitle: String

    private var progress: Double {
        guard totalGB > 0 else { return 0 }
        return min(max(usedGB / totalGB, 0.0), 1.0)
    }

    public init(
        usedGB: Double,
        totalGB: Double,
        unit: String = "GB",
        title: String = "Data Usage",
        subtitle: String = "Renews in 12 days"
    ) {
        self.usedGB = usedGB
        self.totalGB = totalGB
        self.unit = unit
        self.title = title
        self.subtitle = subtitle
    }

    public var body: some View {
        HStack(spacing: 20) {
            ZStack {
                // Background Track
                Circle()
                    .stroke(Color.white.opacity(0.1), lineWidth: 10)
                    .frame(width: 90, height: 90)

                // Progress Arc
                Circle()
                    .trim(from: 0.0, to: CGFloat(progress))
                    .stroke(
                        LinearGradient(
                            colors: progress > 0.85 ? [TelecomColors.warningAmber, TelecomColors.dangerRed] : [TelecomColors.neonCyan, TelecomColors.electricBlue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .frame(width: 90, height: 90)
                    .animation(.spring(response: 0.8, dampingFraction: 0.7), value: progress)

                // Center Percent
                VStack(spacing: 2) {
                    Text("\(Int(progress * 100))%")
                        .font(TelecomTypography.titleSmall)
                        .foregroundColor(.white)
                    Text("used")
                        .font(TelecomTypography.captionSmall)
                        .foregroundColor(TelecomColors.neutralMuted)
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(TelecomTypography.captionMedium)
                    .foregroundColor(TelecomColors.neutralMuted)
                    .textCase(.uppercase)

                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(String(format: "%.1f", usedGB))
                        .font(TelecomTypography.monoNumber)
                        .foregroundColor(.white)
                    Text("/ \(Int(totalGB)) \(unit)")
                        .font(TelecomTypography.bodyMedium)
                        .foregroundColor(TelecomColors.neutralMuted)
                }

                Text(subtitle)
                    .font(TelecomTypography.captionSmall)
                    .foregroundColor(TelecomColors.neonCyan)
            }

            Spacer()
        }
    }
}
