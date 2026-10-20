import SwiftUI

public struct SupportView: View {
    @StateObject private var viewModel = SupportViewModel()

    public init() {}

    public var body: some View {
        NavigationStack {
            ZStack {
                TelecomColors.backgroundGradient.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // 1. Search Bar
                        searchBar

                        // 2. Hardware Troubleshooting Hero Card
                        troubleshootHeroCard

                        // 3. Network Outage & Service Health Status
                        networkHealthCard

                        // 4. Support Tickets Section
                        ticketsSection

                        // 5. FAQs Knowledge Base Accordion
                        faqsSection

                        Color.clear.frame(height: 80)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                }
                .refreshable {
                    viewModel.loadData()
                }
            }
            .navigationTitle("Support Center")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $viewModel.showTroubleshootingWizard) {
                TroubleshootingWizardView()
            }
            .sheet(isPresented: $viewModel.showCreateTicket) {
                CreateTicketView()
            }
        }
    }

    // MARK: - Search Bar
    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(TelecomColors.neutralMuted)
            TextField("Search troubleshooting guides, LEDs, speed issues...", text: $viewModel.searchQuery)
                .foregroundColor(.white)
            if !viewModel.searchQuery.isEmpty {
                Button(action: { viewModel.searchQuery = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(TelecomColors.neutralMuted)
                }
            }
        }
        .padding(12)
        .background(Color.white.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Troubleshoot Hero Card
    private var troubleshootHeroCard: some View {
        GlassCard(cornerRadius: 22, padding: 18, hasGlow: true) {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(TelecomColors.neonCyan.opacity(0.2))
                            .frame(width: 44, height: 44)
                        Image(systemName: "wrench.and.screwdriver.fill")
                            .font(.system(size: 20))
                            .foregroundColor(TelecomColors.neonCyan)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text("MODEM TROUBLESHOOTING WIZARD")
                            .font(TelecomTypography.badge)
                            .foregroundColor(TelecomColors.neonCyan)
                        Text("Automated Hardware & Line Check")
                            .font(TelecomTypography.titleSmall)
                            .foregroundColor(.white)
                    }

                    Spacer()
                }

                Text("Guide through optical fiber RX power, gateway DNS ping, Wi-Fi 7 channel congestion, and adapter voltage checks.")
                    .font(TelecomTypography.bodyMedium)
                    .foregroundColor(TelecomColors.neutralMuted)

                TelecomButton(
                    title: "Launch Interactive Diagnostics",
                    icon: "play.fill",
                    style: .cyanGlow,
                    action: {
                        HapticFeedback.medium()
                        viewModel.showTroubleshootingWizard = true
                    }
                )
            }
        }
    }

    // MARK: - Network Health Card
    private var networkHealthCard: some View {
        GlassCard(cornerRadius: 18, padding: 14) {
            HStack(spacing: 12) {
                Circle()
                    .fill(TelecomColors.successGreen)
                    .frame(width: 10, height: 10)

                VStack(alignment: .leading, spacing: 2) {
                    Text("NO OUTAGES DETECTED IN YOUR AREA")
                        .font(TelecomTypography.badge)
                        .foregroundColor(TelecomColors.successGreen)
                    Text("San Francisco Central OLT Core Hub is running normally with 99.98% uptime.")
                        .font(TelecomTypography.captionSmall)
                        .foregroundColor(TelecomColors.neutralMuted)
                }
            }
        }
    }

    // MARK: - Tickets Section
    private var ticketsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("YOUR SUPPORT TICKETS")
                    .font(TelecomTypography.captionMedium)
                    .foregroundColor(TelecomColors.neutralMuted)
                Spacer()
                Button(action: {
                    HapticFeedback.light()
                    viewModel.showCreateTicket = true
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "plus.circle.fill")
                        Text("New Ticket")
                    }
                    .font(TelecomTypography.captionSmall)
                    .foregroundColor(TelecomColors.neonCyan)
                }
            }

            if viewModel.tickets.isEmpty {
                GlassCard(cornerRadius: 16, padding: 16) {
                    Text("No open support tickets. Everything is running smoothly!")
                        .font(TelecomTypography.captionMedium)
                        .foregroundColor(TelecomColors.neutralMuted)
                }
            } else {
                ForEach(viewModel.tickets) { ticket in
                    NavigationLink(destination: SupportChatView(ticket: ticket)) {
                        GlassCard(cornerRadius: 18, padding: 14) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack(spacing: 6) {
                                        Text(ticket.ticketNumber)
                                            .font(TelecomTypography.badge)
                                            .foregroundColor(TelecomColors.neonCyan)
                                        Text("• \(ticket.category)")
                                            .font(TelecomTypography.captionSmall)
                                            .foregroundColor(TelecomColors.neutralMuted)
                                    }

                                    Text(ticket.title)
                                        .font(TelecomTypography.bodyBold)
                                        .foregroundColor(.white)

                                    if let last = ticket.messages.last {
                                        Text(last.message)
                                            .font(TelecomTypography.captionSmall)
                                            .foregroundColor(TelecomColors.neutralMuted)
                                            .lineLimit(1)
                                    }
                                }

                                Spacer()

                                VStack(alignment: .trailing, spacing: 8) {
                                    StatusBadge(text: ticket.status.displayName.uppercased(), type: .pending)
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(TelecomColors.neutralMuted)
                                }
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }

    // MARK: - FAQs Section
    private var faqsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("FREQUENTLY ASKED QUESTIONS")
                .font(TelecomTypography.captionMedium)
                .foregroundColor(TelecomColors.neutralMuted)

            ForEach(viewModel.filteredFAQs) { faq in
                FAQAccordionRow(faq: faq)
            }
        }
    }
}

private struct FAQAccordionRow: View {
    let faq: DemoDataStore.FAQItem
    @State private var isExpanded: Bool = false

    var body: some View {
        GlassCard(cornerRadius: 16, padding: 14) {
            VStack(alignment: .leading, spacing: 8) {
                Button(action: {
                    HapticFeedback.light()
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        isExpanded.toggle()
                    }
                }) {
                    HStack {
                        Text(faq.question)
                            .font(TelecomTypography.bodyBold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)

                        Spacer()

                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(TelecomColors.neonCyan)
                    }
                }

                if isExpanded {
                    Text(faq.answer)
                        .font(TelecomTypography.bodyMedium)
                        .foregroundColor(TelecomColors.neutralMuted)
                        .padding(.top, 4)
                        .transition(.opacity)
                }
            }
        }
    }
}
