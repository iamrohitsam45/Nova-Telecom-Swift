import SwiftUI

public struct BillHistoryView: View {
    public let invoices: [Invoice]

    public init(invoices: [Invoice] = DemoDataStore.shared.invoices) {
        self.invoices = invoices
    }

    public var body: some View {
        ZStack {
            TelecomColors.backgroundGradient.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 14) {
                    ForEach(invoices) { inv in
                        NavigationLink(destination: InvoiceDetailView(invoice: inv)) {
                            GlassCard(cornerRadius: 18, padding: 16) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack(spacing: 6) {
                                            Text(inv.invoiceNumber)
                                                .font(TelecomTypography.bodyBold)
                                                .foregroundColor(.white)
                                            StatusBadge(text: inv.status.rawValue, type: inv.status == .paid ? .active : .warning)
                                        }

                                        Text("Period: \(inv.billingPeriodStart.formatted(date: .abbreviated, time: .omitted)) - \(inv.billingPeriodEnd.formatted(date: .abbreviated, time: .omitted))")
                                            .font(TelecomTypography.captionSmall)
                                            .foregroundColor(TelecomColors.neutralMuted)

                                        Text(inv.paymentMethod ?? "Apple Pay")
                                            .font(TelecomTypography.captionSmall)
                                            .foregroundColor(TelecomColors.neonCyan)
                                    }

                                    Spacer()

                                    VStack(alignment: .trailing, spacing: 4) {
                                        Text(inv.formattedTotal)
                                            .font(TelecomTypography.titleSmall)
                                            .foregroundColor(TelecomColors.neonCyan)

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
                .padding(16)
            }
        }
        .navigationTitle("Billing & Invoices")
        .navigationBarTitleDisplayMode(.inline)
    }
}
