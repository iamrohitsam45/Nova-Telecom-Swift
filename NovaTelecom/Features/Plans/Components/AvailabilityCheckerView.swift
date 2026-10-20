import SwiftUI

public struct AvailabilityCheckerView: View {
    @State private var postalCode: String = "94107"
    @State private var streetAddress: String = "742 Evergreen Terrace"
    @State private var isChecking: Bool = false
    @State private var result: ServiceAvailabilityResult?
    @Environment(\.dismiss) private var dismiss

    public init() {}

    public var body: some View {
        NavigationStack {
            ZStack {
                TelecomColors.backgroundGradient.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Check Fiber Availability")
                            .font(TelecomTypography.titleLarge)
                            .foregroundColor(.white)

                        Text("Enter your service location to verify multi-gigabit optical fiber connectivity and installation eligibility.")
                            .font(TelecomTypography.bodyMedium)
                            .foregroundColor(TelecomColors.neutralMuted)

                        GlassCard(cornerRadius: 20, padding: 18) {
                            VStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("STREET ADDRESS")
                                        .font(TelecomTypography.badge)
                                        .foregroundColor(TelecomColors.neutralMuted)
                                    TextField("Street Address", text: $streetAddress)
                                        .padding(12)
                                        .background(Color.white.opacity(0.08))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .foregroundColor(.white)
                                }

                                VStack(alignment: .leading, spacing: 6) {
                                    Text("POSTAL / ZIP CODE")
                                        .font(TelecomTypography.badge)
                                        .foregroundColor(TelecomColors.neutralMuted)
                                    TextField("Postal Code", text: $postalCode)
                                        .keyboardType(.numberPad)
                                        .padding(12)
                                        .background(Color.white.opacity(0.08))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .foregroundColor(.white)
                                }

                                TelecomButton(
                                    title: "Verify Optical Coverage",
                                    icon: "network",
                                    style: .cyanGlow,
                                    isLoading: isChecking,
                                    action: checkCoverage
                                )
                            }
                        }

                        if let res = result {
                            coverageResultCard(res)
                        }
                    }
                    .padding(16)
                }
            }
            .navigationTitle("Coverage Checker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                        .foregroundColor(TelecomColors.neonCyan)
                }
            }
        }
    }

    private func checkCoverage() {
        isChecking = true
        HapticFeedback.light()
        Task {
            try? await Task.sleep(nanoseconds: 600_000_000)
            let isAvailable = !postalCode.hasPrefix("00")
            result = ServiceAvailabilityResult(
                addressSearched: streetAddress,
                isFiberAvailable: isAvailable,
                is5GHomeAvailable: true,
                maxDownloadSpeedMbps: isAvailable ? 10000 : 300,
                maxUploadSpeedMbps: isAvailable ? 10000 : 100,
                technologyType: isAvailable ? "XGS-PON 10Gbps Symmetrical Optical Fiber" : "5G Ultra Wideband Fixed Wireless",
                estimatedInstallationDays: 2
            )
            isChecking = false
            HapticFeedback.success()
        }
    }

    private func coverageResultCard(_ res: ServiceAvailabilityResult) -> some View {
        GlassCard(cornerRadius: 20, padding: 18, hasGlow: res.isFiberAvailable) {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Image(systemName: res.isFiberAvailable ? "checkmark.seal.fill" : "exclamationmark.triangle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(res.isFiberAvailable ? TelecomColors.successGreen : TelecomColors.warningAmber)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(res.isFiberAvailable ? "Fiber Ready Location!" : "5G Home Internet Available")
                            .font(TelecomTypography.titleSmall)
                            .foregroundColor(.white)
                        Text(res.technologyType)
                            .font(TelecomTypography.captionSmall)
                            .foregroundColor(TelecomColors.neonCyan)
                    }
                }

                Divider().background(Color.white.opacity(0.12))

                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("MAX LINE SPEED")
                            .font(TelecomTypography.badge)
                            .foregroundColor(TelecomColors.neutralMuted)
                        Text(DataSizeFormatter.formatSpeed(mbps: res.maxDownloadSpeedMbps))
                            .font(TelecomTypography.titleMedium)
                            .foregroundColor(.white)
                    }

                    Spacer()

                    VStack(alignment: .leading, spacing: 2) {
                        Text("DISPATCH TIME")
                            .font(TelecomTypography.badge)
                            .foregroundColor(TelecomColors.neutralMuted)
                        Text("\(res.estimatedInstallationDays) Business Days")
                            .font(TelecomTypography.bodyBold)
                            .foregroundColor(TelecomColors.successGreen)
                    }
                }

                TelecomButton(
                    title: "Select Fiber Plan",
                    icon: "arrow.right",
                    style: .primary,
                    action: { dismiss() }
                )
            }
        }
    }
}
