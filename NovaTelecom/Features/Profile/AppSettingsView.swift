import SwiftUI

public struct AppSettingsView: View {
    @State private var selectedCurrency: String = "USD"
    @State private var isDemoMode: Bool = true
    @State private var biometricAuth: Bool = true
    @State private var pushNotifications: Bool = true
    @State private var networkDiagnosticsConsent: Bool = true
    @State private var showExportAlert: Bool = false

    private let currencies = ["USD ($)", "EUR (€)", "GBP (£)"]

    public init() {}

    public var body: some View {
        ZStack {
            TelecomColors.backgroundGradient.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    // Currency & Region
                    GlassCard(cornerRadius: 18, padding: 16) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("CURRENCY & LOCALIZATION")
                                .font(TelecomTypography.badge)
                                .foregroundColor(TelecomColors.neutralMuted)

                            Picker("Currency", selection: $selectedCurrency) {
                                ForEach(currencies, id: \.self) { c in
                                    Text(c).tag(c)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                    }

                    // Environment & Demo Mode
                    GlassCard(cornerRadius: 18, padding: 16) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("ENVIRONMENT & DATA")
                                .font(TelecomTypography.badge)
                                .foregroundColor(TelecomColors.neutralMuted)

                            Toggle(isOn: $isDemoMode) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Demo Simulation Mode")
                                        .font(TelecomTypography.bodyBold)
                                        .foregroundColor(.white)
                                    Text("Runs high-fidelity offline simulation when backend server is unavailable")
                                        .font(TelecomTypography.captionSmall)
                                        .foregroundColor(TelecomColors.neutralMuted)
                                }
                            }
                            .tint(TelecomColors.neonCyan)
                            .onChange(of: isDemoMode) { newValue in
                                NetworkConfiguration.shared.isDemoMode = newValue
                            }
                        }
                    }

                    // Security & Privacy
                    GlassCard(cornerRadius: 18, padding: 16) {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("SECURITY & GDPR PRIVACY")
                                .font(TelecomTypography.badge)
                                .foregroundColor(TelecomColors.neutralMuted)

                            Toggle("Face ID / Biometric Sign-in", isOn: $biometricAuth)
                                .font(TelecomTypography.bodyMedium)
                                .foregroundColor(.white)
                                .tint(TelecomColors.neonCyan)

                            Divider().background(Color.white.opacity(0.1))

                            Toggle("Transactional Push Alerts", isOn: $pushNotifications)
                                .font(TelecomTypography.bodyMedium)
                                .foregroundColor(.white)
                                .tint(TelecomColors.neonCyan)

                            Divider().background(Color.white.opacity(0.1))

                            Toggle("Share Anonymous Line Diagnostics", isOn: $networkDiagnosticsConsent)
                                .font(TelecomTypography.bodyMedium)
                                .foregroundColor(.white)
                                .tint(TelecomColors.neonCyan)
                                .onChange(of: networkDiagnosticsConsent) { val in
                                    TelecomAnalytics.shared.setConsent(granted: val)
                                }
                        }
                    }

                    // Data Rights Actions
                    GlassCard(cornerRadius: 18, padding: 16) {
                        VStack(spacing: 12) {
                            Button(action: {
                                HapticFeedback.light()
                                showExportAlert = true
                            }) {
                                HStack {
                                    Image(systemName: "square.and.arrow.down")
                                    Text("Export Account Data (GDPR)")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                                .font(TelecomTypography.bodyMedium)
                                .foregroundColor(TelecomColors.neonCyan)
                            }

                            Divider().background(Color.white.opacity(0.1))

                            Button(action: {
                                HapticFeedback.warning()
                            }) {
                                HStack {
                                    Image(systemName: "trash")
                                    Text("Request Account & Service Termination")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                                .font(TelecomTypography.bodyMedium)
                                .foregroundColor(TelecomColors.dangerRed)
                            }
                        }
                    }

                    // App Version Footer
                    VStack(spacing: 4) {
                        Text("Nova Telecom iOS Client v2.5.0 (Build 2026.10)")
                            .font(TelecomTypography.captionSmall)
                            .foregroundColor(TelecomColors.neutralMuted)
                        Text("Secure End-to-End TLS 1.3 • AES-256 Keychain Encryption")
                            .font(TelecomTypography.captionSmall)
                            .foregroundColor(TelecomColors.neutralMuted.opacity(0.7))
                    }
                    .padding(.top, 12)
                }
                .padding(16)
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Data Export Queued", isPresented: $showExportAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("A full export of your personal telecom usage records, invoices, and support logs has been prepared.")
        }
    }
}
