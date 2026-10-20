import SwiftUI

public struct OrderConfirmationView: View {
    public let order: Order
    public let onDone: () -> Void

    public init(order: Order, onDone: @escaping () -> Void) {
        self.order = order
        self.onDone = onDone
    }

    public var body: some View {
        VStack(spacing: 24) {
            Spacer()

            ZStack {
                Circle()
                    .fill(TelecomColors.successGreen.opacity(0.18))
                    .frame(width: 90, height: 90)

                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 64))
                    .foregroundColor(TelecomColors.successGreen)
            }

            VStack(spacing: 8) {
                Text("Order Confirmed!")
                    .font(TelecomTypography.titleLarge)
                    .foregroundColor(.white)

                Text("Thank you for your purchase. We are preparing your telecom hardware shipment.")
                    .font(TelecomTypography.bodyMedium)
                    .foregroundColor(TelecomColors.neutralMuted)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }

            GlassCard(cornerRadius: 20, padding: 16) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("ORDER NUMBER")
                            .font(TelecomTypography.badge)
                            .foregroundColor(TelecomColors.neutralMuted)
                        Spacer()
                        Text(order.orderNumber)
                            .font(TelecomTypography.bodyBold)
                            .foregroundColor(TelecomColors.neonCyan)
                    }

                    if let trk = order.trackingNumber {
                        HStack {
                            Text("TRACKING NUMBER")
                                .font(TelecomTypography.badge)
                                .foregroundColor(TelecomColors.neutralMuted)
                            Spacer()
                            Text(trk)
                                .font(TelecomTypography.captionSmall)
                                .foregroundColor(.white)
                        }
                    }

                    HStack {
                        Text("TOTAL CHARGED")
                            .font(TelecomTypography.badge)
                            .foregroundColor(TelecomColors.neutralMuted)
                        Spacer()
                        Text(order.formattedTotal)
                            .font(TelecomTypography.titleSmall)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.horizontal, 16)

            Spacer()

            TelecomButton(
                title: "View Orders & Track Shipment",
                icon: "arrow.right",
                style: .primary,
                action: onDone
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
    }
}
