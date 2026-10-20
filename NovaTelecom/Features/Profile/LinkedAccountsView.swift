import SwiftUI

public struct LinkedAccountsView: View {
    private let simCards = DemoDataStore.shared.simCards
    private let broadband = DemoDataStore.shared.broadbandConnection
    private let dth = DemoDataStore.shared.dthAccount
    private let subscriptions = DemoDataStore.shared.streamingSubscriptions

    public init() {}

    public var body: some View {
        ZStack {
            TelecomColors.backgroundGradient.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    // Broadband Section
                    sectionHeader(title: "PRIMARY BROADBAND CONNECTION", icon: "bolt.horizontal.fill")
                    GlassCard(cornerRadius: 18, padding: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(broadband.serviceIdentifier)
                                    .font(TelecomTypography.titleSmall)
                                    .foregroundColor(.white)
                                Spacer()
                                StatusBadge(text: broadband.isOnline ? "ACTIVE" : "OFFLINE", type: .active)
                            }
                            Text("Plan: \(broadband.planName)")
                                .font(TelecomTypography.bodyMedium)
                                .foregroundColor(TelecomColors.neonCyan)
                            Text("Router: \(broadband.routerModel)")
                                .font(TelecomTypography.captionSmall)
                                .foregroundColor(TelecomColors.neutralMuted)
                            Text("Gateway IP: \(broadband.ipAddress) • MAC: 3C:84:6A:90:E2:11")
                                .font(TelecomTypography.captionSmall)
                                .foregroundColor(TelecomColors.neutralMuted)
                        }
                    }

                    // SIM Cards Section
                    sectionHeader(title: "LINKED MOBILE SIMS", icon: "simcard.2.fill")
                    ForEach(simCards) { sim in
                        GlassCard(cornerRadius: 18, padding: 16) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack(spacing: 6) {
                                        Text(sim.phoneNumber)
                                            .font(TelecomTypography.bodyBold)
                                            .foregroundColor(.white)
                                        StatusBadge(text: sim.isEsim ? "eSIM" : "NANO-SIM", type: .cyber)
                                    }
                                    Text("Plan: \(sim.planName)")
                                        .font(TelecomTypography.captionSmall)
                                        .foregroundColor(TelecomColors.neonCyan)
                                    Text("ICCID: \(sim.iccid)")
                                        .font(TelecomTypography.captionSmall)
                                        .foregroundColor(TelecomColors.neutralMuted)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("\(String(format: "%.1f", sim.dataRemainingGB)) GB")
                                        .font(TelecomTypography.titleSmall)
                                        .foregroundColor(.white)
                                    Text("remaining")
                                        .font(TelecomTypography.captionSmall)
                                        .foregroundColor(TelecomColors.neutralMuted)
                                }
                            }
                        }
                    }

                    // DTH Section
                    sectionHeader(title: "DTH SATELLITE TV", icon: "tv.fill")
                    GlassCard(cornerRadius: 18, padding: 16) {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(dth.packageName)
                                    .font(TelecomTypography.bodyBold)
                                    .foregroundColor(.white)
                                Spacer()
                                StatusBadge(text: "ACTIVE", type: .active)
                            }
                            Text("Subscriber ID: \(dth.subscriberNumber) • Smart Card: \(dth.smartCardNumber)")
                                .font(TelecomTypography.captionSmall)
                                .foregroundColor(TelecomColors.neutralMuted)
                        }
                    }

                    // Subscriptions Section
                    sectionHeader(title: "PARTNER OTT SUBSCRIPTIONS", icon: "play.tv.fill")
                    ForEach(subscriptions) { sub in
                        GlassCard(cornerRadius: 18, padding: 14) {
                            HStack {
                                Image(systemName: sub.iconUrl)
                                    .foregroundColor(TelecomColors.neonCyan)
                                    .font(.system(size: 20))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(sub.providerName)
                                        .font(TelecomTypography.bodyBold)
                                        .foregroundColor(.white)
                                    Text(sub.tierDescription)
                                        .font(TelecomTypography.captionSmall)
                                        .foregroundColor(TelecomColors.neutralMuted)
                                }
                                Spacer()
                                StatusBadge(text: sub.isActivated ? "LINKED" : "AVAILABLE", type: sub.isActivated ? .active : .info)
                            }
                        }
                    }
                }
                .padding(16)
            }
        }
        .navigationTitle("Linked Services")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sectionHeader(title: String, icon: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundColor(TelecomColors.neonCyan)
            Text(title)
                .font(TelecomTypography.captionMedium)
                .foregroundColor(TelecomColors.neutralMuted)
            Spacer()
        }
        .padding(.horizontal, 4)
    }
}
