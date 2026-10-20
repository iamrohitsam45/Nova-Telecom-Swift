import SwiftUI

public struct ProfileView: View {
    @ObservedObject private var userSession = UserSession.shared
    @StateObject private var viewModel = ProfileViewModel()

    public init() {}

    public var body: some View {
        NavigationStack {
            ZStack {
                TelecomColors.backgroundGradient.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 18) {
                        // Profile Avatar & Contact Card
                        userProfileCard

                        // Service Address Card
                        serviceAddressCard

                        // Navigation Menu Card
                        menuGroupCard

                        // Sign Out Button
                        signoutButton

                        Color.clear.frame(height: 80)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                }
            }
            .navigationTitle("Account Profile")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $viewModel.showAuthModal) {
                AuthView()
            }
        }
    }

    // MARK: - User Profile Card
    private var userProfileCard: some View {
        GlassCard(cornerRadius: 22, padding: 18, hasGlow: true) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(TelecomColors.heroGradient)
                        .frame(width: 64, height: 64)

                    Text(userSession.currentUser?.fullName.prefix(1).uppercased() ?? "A")
                        .font(TelecomTypography.titleLarge)
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(userSession.currentUser?.fullName ?? "Alex Mercer")
                            .font(TelecomTypography.titleMedium)
                            .foregroundColor(.white)
                        StatusBadge(text: "VERIFIED", type: .active)
                    }

                    Text(userSession.currentUser?.email ?? "alex.mercer@novatelecom.io")
                        .font(TelecomTypography.captionMedium)
                        .foregroundColor(TelecomColors.neutralMuted)

                    Text(userSession.currentUser?.phoneNumber ?? "+1 (555) 392-8821")
                        .font(TelecomTypography.captionSmall)
                        .foregroundColor(TelecomColors.neonCyan)
                }

                Spacer()
            }
        }
    }

    // MARK: - Service Address Card
    private var serviceAddressCard: some View {
        GlassCard(cornerRadius: 18, padding: 16) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "house.fill")
                        .foregroundColor(TelecomColors.neonCyan)
                    Text("PRIMARY FIBER INSTALLATION ADDRESS")
                        .font(TelecomTypography.badge)
                        .foregroundColor(TelecomColors.neutralMuted)
                    Spacer()
                }

                Text(userSession.currentUser?.primaryAddress?.formattedAddress ?? "742 Evergreen Terrace, Suite 4B\nSan Francisco, CA 94107")
                    .font(TelecomTypography.bodyMedium)
                    .foregroundColor(.white)
            }
        }
    }

    // MARK: - Menu Group Card
    private var menuGroupCard: some View {
        GlassCard(cornerRadius: 20, padding: 12) {
            VStack(spacing: 4) {
                NavigationLink(destination: LinkedAccountsView()) {
                    menuRow(icon: "network", title: "Linked Services & SIMs", subtitle: "Manage active fiber router, eSIMs, and DTH accounts")
                }
                .buttonStyle(PlainButtonStyle())

                Divider().background(Color.white.opacity(0.08))

                NavigationLink(destination: BillHistoryView()) {
                    menuRow(icon: "doc.text.fill", title: "Billing & Invoices", subtitle: "Monthly statements and downloadable PDF receipts")
                }
                .buttonStyle(PlainButtonStyle())

                Divider().background(Color.white.opacity(0.08))

                NavigationLink(destination: OrderHistoryView()) {
                    menuRow(icon: "shippingbox.fill", title: "Hardware Orders", subtitle: "Shipment status, courier tracking, and returns")
                }
                .buttonStyle(PlainButtonStyle())

                Divider().background(Color.white.opacity(0.08))

                NavigationLink(destination: AppSettingsView()) {
                    menuRow(icon: "gearshape.fill", title: "App Settings & Privacy", subtitle: "Demo mode, currency, biometrics, GDPR data export")
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }

    private func menuRow(icon: String, title: String, subtitle: String) -> some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 38, height: 38)
                Image(systemName: icon)
                    .foregroundColor(TelecomColors.neonCyan)
                    .font(.system(size: 16))
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(TelecomTypography.bodyBold)
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(TelecomTypography.captionSmall)
                    .foregroundColor(TelecomColors.neutralMuted)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(TelecomColors.neutralMuted)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 6)
    }

    // MARK: - Sign Out Button
    private var signoutButton: some View {
        Button(action: {
            HapticFeedback.light()
            viewModel.showAuthModal = true
        }) {
            HStack(spacing: 8) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                Text("Switch Account or Sign In")
            }
            .font(TelecomTypography.bodyBold)
            .foregroundColor(TelecomColors.neonCyan)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.white.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(TelecomColors.neonCyan.opacity(0.3), lineWidth: 1)
            )
        }
    }
}
