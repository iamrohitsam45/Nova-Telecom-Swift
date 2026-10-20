import SwiftUI

public struct DiagnosticStep: Identifiable {
    public let id: Int
    public let title: String
    public let subtitle: String
    public let icon: String
    public var status: StepStatus

    public enum StepStatus {
        case pending
        case running
        case passed
        case failed
    }
}

public struct TroubleshootingWizardView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentStepIndex: Int = 0
    @State private var isRunningDiagnosis: Bool = false
    @State private var opticalPowerDbm: Double = -20.5
    @State private var latencyMs: Int = 4
    @State private var packetLoss: Double = 0.0
    @State private var diagnosisComplete: Bool = false
    @State private var showCreateTicketSheet: Bool = false

    @State private var steps: [DiagnosticStep] = [
        DiagnosticStep(id: 0, title: "Power Supply & Voltage", subtitle: "Validating 12V DC input and internal thermal sensors", icon: "bolt.fill", status: .pending),
        DiagnosticStep(id: 1, title: "Optical Fiber SC/APC Link", subtitle: "Reading SFP transceiver telemetry & RX signal power (-20.5 dBm)", icon: "cable.connector", status: .pending),
        DiagnosticStep(id: 2, title: "Gateway & DNS Latency", subtitle: "Pinging optical line terminal (OLT) and root DNS servers", icon: "globe", status: .pending),
        DiagnosticStep(id: 3, title: "Wi-Fi 7 Radio Congestion", subtitle: "Analyzing 2.4GHz, 5GHz, and 6GHz channel spectrum noise", icon: "antenna.radiowaves.left.and.right", status: .pending),
        DiagnosticStep(id: 4, title: "Device Throughput Test", subtitle: "Executing multi-stream upload and download speed telemetry", icon: "speedometer", status: .pending)
    ]

    public init() {}

    public var body: some View {
        NavigationStack {
            ZStack {
                TelecomColors.backgroundGradient.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Interactive Hardware Diagnostics")
                            .font(TelecomTypography.titleLarge)
                            .foregroundColor(.white)

                        Text("Run automated hardware telemetry checks across your optical line, router LEDs, and wireless radios.")
                            .font(TelecomTypography.bodyMedium)
                            .foregroundColor(TelecomColors.neutralMuted)

                        // Progress Card
                        GlassCard(cornerRadius: 20, padding: 16, hasGlow: true) {
                            VStack(spacing: 16) {
                                ForEach(steps) { step in
                                    stepRow(step)
                                    if step.id < steps.count - 1 {
                                        Divider().background(Color.white.opacity(0.1))
                                    }
                                }
                            }
                        }

                        // Telemetry Metrics Box
                        if diagnosisComplete {
                            telemetryMetricsCard
                        }

                        // Action Buttons
                        if !isRunningDiagnosis && !diagnosisComplete {
                            TelecomButton(
                                title: "Begin Diagnostic Sequence",
                                icon: "play.fill",
                                style: .cyanGlow,
                                action: runDiagnostics
                            )
                        } else if diagnosisComplete {
                            VStack(spacing: 12) {
                                TelecomButton(
                                    title: "All Systems Operational (Done)",
                                    icon: "checkmark.circle.fill",
                                    style: .primary,
                                    action: { dismiss() }
                                )

                                Button(action: { showCreateTicketSheet = true }) {
                                    Text("Still Having Issues? Open Support Ticket")
                                        .font(TelecomTypography.captionMedium)
                                        .foregroundColor(TelecomColors.neonCyan)
                                }
                            }
                        }
                    }
                    .padding(16)
                }
            }
            .navigationTitle("Modem Troubleshooting")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                        .foregroundColor(TelecomColors.neonCyan)
                }
            }
            .sheet(isPresented: $showCreateTicketSheet) {
                CreateTicketView(defaultCategory: "Broadband Diagnostics", initialDiagnosisNote: "Modem wizard completed. Optical RX power: -20.5dBm, Latency: 4ms, Packet Loss: 0.0%.")
            }
        }
    }

    private func stepRow(_ step: DiagnosticStep) -> some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 40, height: 40)

                Image(systemName: step.icon)
                    .font(.system(size: 16))
                    .foregroundColor(TelecomColors.neonCyan)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(step.title)
                    .font(TelecomTypography.bodyBold)
                    .foregroundColor(.white)
                Text(step.subtitle)
                    .font(TelecomTypography.captionSmall)
                    .foregroundColor(TelecomColors.neutralMuted)
            }

            Spacer()

            switch step.status {
            case .pending:
                Circle()
                    .stroke(Color.white.opacity(0.2), lineWidth: 2)
                    .frame(width: 20, height: 20)
            case .running:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: TelecomColors.neonCyan))
                    .scaleEffect(0.8)
            case .passed:
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(TelecomColors.successGreen)
                    .font(.system(size: 20))
            case .failed:
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(TelecomColors.dangerRed)
                    .font(.system(size: 20))
            }
        }
    }

    private var telemetryMetricsCard: some View {
        GlassCard(cornerRadius: 18, padding: 14) {
            VStack(alignment: .leading, spacing: 10) {
                Text("HARDWARE TELEMETRY SUMMARY")
                    .font(TelecomTypography.badge)
                    .foregroundColor(TelecomColors.neonCyan)

                HStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("OPTICAL RX POWER")
                            .font(TelecomTypography.badge)
                            .foregroundColor(TelecomColors.neutralMuted)
                        Text("\(String(format: "%.1f", opticalPowerDbm)) dBm")
                            .font(TelecomTypography.bodyBold)
                            .foregroundColor(TelecomColors.successGreen)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text("GATEWAY PING")
                            .font(TelecomTypography.badge)
                            .foregroundColor(TelecomColors.neutralMuted)
                        Text("\(latencyMs) ms")
                            .font(TelecomTypography.bodyBold)
                            .foregroundColor(.white)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text("PACKET LOSS")
                            .font(TelecomTypography.badge)
                            .foregroundColor(TelecomColors.neutralMuted)
                        Text("\(String(format: "%.1f", packetLoss))%")
                            .font(TelecomTypography.bodyBold)
                            .foregroundColor(TelecomColors.successGreen)
                    }
                }
            }
        }
    }

    private func runDiagnostics() {
        isRunningDiagnosis = true
        HapticFeedback.light()

        Task {
            for i in 0..<steps.count {
                steps[i].status = .running
                try? await Task.sleep(nanoseconds: 600_000_000)
                steps[i].status = .passed
                HapticFeedback.light()
            }
            diagnosisComplete = true
            isRunningDiagnosis = false
            HapticFeedback.success()
        }
    }
}
