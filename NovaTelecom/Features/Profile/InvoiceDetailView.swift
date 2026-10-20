import SwiftUI

public struct InvoiceDetailView: View {
    public let invoice: Invoice
    @State private var isDownloadingPDF: Bool = false
    @State private var downloadSuccess: Bool = false

    public init(invoice: Invoice) {
        self.invoice = invoice
    }

    public var body: some View {
        ZStack {
            TelecomColors.backgroundGradient.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    // Invoice Status & Total Header
                    GlassCard(cornerRadius: 22, padding: 18, hasGlow: true) {
                        VStack(spacing: 12) {
                            HStack {
                                Text(invoice.invoiceNumber)
                                    .font(TelecomTypography.titleSmall)
                                    .foregroundColor(.white)
                                Spacer()
                                StatusBadge(text: invoice.status.rawValue, type: invoice.status == .paid ? .active : .warning)
                            }

                            Divider().background(Color.white.opacity(0.12))

                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("TOTAL PAID")
                                        .font(TelecomTypography.badge)
                                        .foregroundColor(TelecomColors.neutralMuted)
                                    Text(invoice.formattedTotal)
                                        .font(TelecomTypography.heroLarge)
                                        .foregroundColor(TelecomColors.neonCyan)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("DUE DATE")
                                        .font(TelecomTypography.badge)
                                        .foregroundColor(TelecomColors.neutralMuted)
                                    Text(invoice.dueDate.formatted(date: .abbreviated, time: .omitted))
                                        .font(TelecomTypography.bodyBold)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }

                    // Line Items Card
                    GlassCard(cornerRadius: 20, padding: 16) {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("ITEMIZED CHARGES")
                                .font(TelecomTypography.captionMedium)
                                .foregroundColor(TelecomColors.neutralMuted)

                            ForEach(invoice.lineItems) { item in
                                HStack {
                                    Text(item.description)
                                        .font(TelecomTypography.bodyMedium)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text(item.formattedAmount)
                                        .font(TelecomTypography.bodyBold)
                                        .foregroundColor(.white)
                                }
                                Divider().background(Color.white.opacity(0.1))
                            }

                            HStack {
                                Text("Payment Method")
                                    .font(TelecomTypography.captionMedium)
                                    .foregroundColor(TelecomColors.neutralMuted)
                                Spacer()
                                Text(invoice.paymentMethod ?? "Apple Pay")
                                    .font(TelecomTypography.bodyBold)
                                    .foregroundColor(.white)
                            }
                        }
                    }

                    // Download PDF Button
                    TelecomButton(
                        title: downloadSuccess ? "Invoice Downloaded to Files" : "Download PDF Statement",
                        icon: downloadSuccess ? "checkmark.circle.fill" : "arrow.down.doc.fill",
                        style: downloadSuccess ? .cyanGlow : .primary,
                        isLoading: isDownloadingPDF,
                        action: downloadPDF
                    )
                }
                .padding(16)
            }
        }
        .navigationTitle("Invoice Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func downloadPDF() {
        isDownloadingPDF = true
        HapticFeedback.light()
        Task {
            try? await Task.sleep(nanoseconds: 800_000_000)
            isDownloadingPDF = false
            downloadSuccess = true
            HapticFeedback.success()
        }
    }
}
