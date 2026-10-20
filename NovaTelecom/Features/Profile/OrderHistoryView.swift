import SwiftUI

public struct OrderHistoryView: View {
    public let orders: [Order]

    public init(orders: [Order] = DemoDataStore.shared.orders) {
        self.orders = orders
    }

    public var body: some View {
        ZStack {
            TelecomColors.backgroundGradient.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 14) {
                    if orders.isEmpty {
                        GlassCard(cornerRadius: 18, padding: 20) {
                            Text("No hardware orders yet. Visit the Marketplace to purchase routers and mesh equipment.")
                                .font(TelecomTypography.bodyMedium)
                                .foregroundColor(TelecomColors.neutralMuted)
                        }
                    } else {
                        ForEach(orders) { order in
                            GlassCard(cornerRadius: 20, padding: 16) {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(order.orderNumber)
                                                .font(TelecomTypography.titleSmall)
                                                .foregroundColor(.white)
                                            Text(order.createdAt.formatted(date: .abbreviated, time: .shortened))
                                                .font(TelecomTypography.captionSmall)
                                                .foregroundColor(TelecomColors.neutralMuted)
                                        }

                                        Spacer()

                                        StatusBadge(text: order.status.rawValue, type: .active)
                                    }

                                    Divider().background(Color.white.opacity(0.1))

                                    // Items
                                    ForEach(order.items) { item in
                                        HStack {
                                            Text("\(item.quantity)x \(item.productName)")
                                                .font(TelecomTypography.bodyMedium)
                                                .foregroundColor(.white)
                                            Spacer()
                                            Text(item.formattedTotal)
                                                .font(TelecomTypography.bodyBold)
                                                .foregroundColor(TelecomColors.neonCyan)
                                        }
                                    }

                                    // Tracking Row
                                    if let trk = order.trackingNumber {
                                        HStack(spacing: 6) {
                                            Image(systemName: "shippingbox.fill")
                                                .foregroundColor(TelecomColors.neonCyan)
                                            Text("Tracking: \(trk)")
                                                .font(TelecomTypography.captionSmall)
                                                .foregroundColor(TelecomColors.neonCyan)
                                        }
                                        .padding(8)
                                        .background(Color.white.opacity(0.05))
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(16)
            }
        }
        .navigationTitle("Hardware Orders")
        .navigationBarTitleDisplayMode(.inline)
    }
}
