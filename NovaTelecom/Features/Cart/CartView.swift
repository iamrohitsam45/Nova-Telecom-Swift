import SwiftUI

public struct CartView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = CartViewModel()

    public init() {}

    public var body: some View {
        NavigationStack {
            ZStack {
                TelecomColors.backgroundGradient.ignoresSafeArea()

                if viewModel.cart.items.isEmpty {
                    emptyCartView
                } else {
                    ScrollView {
                        VStack(spacing: 18) {
                            // Free Shipping Progress
                            freeShippingBar

                            // Item Cards
                            ForEach(viewModel.cart.items) { item in
                                cartItemRow(item)
                            }

                            // Promo Code Box
                            promoCodeCard

                            // Order Summary
                            orderSummaryCard

                            // Checkout Button
                            TelecomButton(
                                title: "Proceed to Checkout (\(viewModel.cart.formattedGrandTotal))",
                                icon: "lock.shield.fill",
                                style: .primary,
                                action: {
                                    viewModel.showCheckoutView = true
                                }
                            )
                        }
                        .padding(16)
                    }
                }
            }
            .navigationTitle("Shopping Cart")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                        .foregroundColor(TelecomColors.neonCyan)
                }
            }
            .sheet(isPresented: $viewModel.showCheckoutView) {
                CheckoutView {
                    viewModel.refresh()
                    dismiss()
                }
            }
        }
    }

    private var emptyCartView: some View {
        VStack(spacing: 16) {
            Image(systemName: "cart.badge.questionmark")
                .font(.system(size: 64))
                .foregroundColor(TelecomColors.neutralMuted)

            Text("Your cart is empty")
                .font(TelecomTypography.titleMedium)
                .foregroundColor(.white)

            Text("Explore Wi-Fi 7 routers, mesh systems, and fiber optic accessories in the Marketplace.")
                .font(TelecomTypography.bodyMedium)
                .foregroundColor(TelecomColors.neutralMuted)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            TelecomButton(
                title: "Explore Hardware",
                icon: "bag.fill",
                style: .primary,
                isFullWidth: false,
                action: { dismiss() }
            )
        }
        .padding()
    }

    private var freeShippingBar: some View {
        let current = Double(viewModel.cart.itemsSubtotalMinorUnits) / 100.0
        let threshold = 100.0
        let progress = min(max(current / threshold, 0.0), 1.0)
        let remaining = max(threshold - current, 0.0)

        return GlassCard(cornerRadius: 16, padding: 12) {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: "shippingbox.fill")
                        .foregroundColor(progress >= 1.0 ? TelecomColors.successGreen : TelecomColors.neonCyan)
                    if progress >= 1.0 {
                        Text("You've unlocked Free Express Shipping!")
                            .font(TelecomTypography.captionMedium)
                            .foregroundColor(TelecomColors.successGreen)
                            .fontWeight(.bold)
                    } else {
                        Text("Add $\(String(format: "%.2f", remaining)) more for Free Shipping")
                            .font(TelecomTypography.captionSmall)
                            .foregroundColor(.white)
                    }
                    Spacer()
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.1))
                            .frame(height: 6)

                        Capsule()
                            .fill(LinearGradient(colors: [TelecomColors.neonCyan, TelecomColors.successGreen], startPoint: .leading, endPoint: .trailing))
                            .frame(width: geo.size.width * CGFloat(progress), height: 6)
                    }
                }
                .frame(height: 6)
            }
        }
    }

    private func cartItemRow(_ item: CartItem) -> some View {
        GlassCard(cornerRadius: 18, padding: 14) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.06))
                        .frame(width: 70, height: 70)

                    Image(systemName: item.product.category.iconName)
                        .font(.system(size: 28))
                        .foregroundColor(TelecomColors.neonCyan)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.product.name)
                        .font(TelecomTypography.bodyBold)
                        .foregroundColor(.white)
                        .lineLimit(2)

                    Text(item.formattedSubtotal)
                        .font(TelecomTypography.titleSmall)
                        .foregroundColor(TelecomColors.neonCyan)

                    // Quantity Stepper
                    HStack(spacing: 12) {
                        Button(action: {
                            viewModel.updateQuantity(itemId: item.id, quantity: item.quantity - 1)
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(TelecomColors.neutralMuted)
                        }

                        Text("\(item.quantity)")
                            .font(TelecomTypography.bodyBold)
                            .foregroundColor(.white)

                        Button(action: {
                            viewModel.updateQuantity(itemId: item.id, quantity: item.quantity + 1)
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(TelecomColors.neonCyan)
                        }

                        Spacer()

                        Button(action: {
                            viewModel.removeItem(itemId: item.id)
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(TelecomColors.dangerRed)
                                .font(.system(size: 14))
                        }
                    }
                    .padding(.top, 4)
                }
            }
        }
    }

    private var promoCodeCard: some View {
        GlassCard(cornerRadius: 16, padding: 12) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    TextField("Enter Promo Code (e.g. NOVA50)", text: $viewModel.promoCodeInput)
                        .textCase(.uppercase)
                        .padding(10)
                        .background(Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .foregroundColor(.white)

                    Button("Apply") {
                        viewModel.applyPromoCode()
                    }
                    .font(TelecomTypography.bodyBold)
                    .foregroundColor(TelecomColors.neonCyan)
                    .padding(.horizontal, 12)
                }

                if let msg = viewModel.promoMessage {
                    Text(msg)
                        .font(TelecomTypography.captionSmall)
                        .foregroundColor(TelecomColors.neonCyan)
                }
            }
        }
    }

    private var orderSummaryCard: some View {
        GlassCard(cornerRadius: 18, padding: 16) {
            VStack(spacing: 10) {
                summaryRow(title: "Subtotal", value: CurrencyFormatter.format(minorUnits: viewModel.cart.itemsSubtotalMinorUnits))

                if viewModel.cart.promoDiscountMinorUnits > 0 {
                    summaryRow(title: "Promo Discount", value: "-\(CurrencyFormatter.format(minorUnits: viewModel.cart.promoDiscountMinorUnits))", highlight: true)
                }

                summaryRow(title: "Estimated Sales Tax (8%)", value: CurrencyFormatter.format(minorUnits: viewModel.cart.estimatedTaxMinorUnits))

                summaryRow(
                    title: "Express Courier Shipping",
                    value: viewModel.cart.shippingMinorUnits == 0 ? "FREE" : CurrencyFormatter.format(minorUnits: viewModel.cart.shippingMinorUnits)
                )

                Divider().background(Color.white.opacity(0.12))

                HStack {
                    Text("TOTAL")
                        .font(TelecomTypography.titleSmall)
                        .foregroundColor(.white)
                    Spacer()
                    Text(viewModel.cart.formattedGrandTotal)
                        .font(TelecomTypography.titleLarge)
                        .foregroundColor(TelecomColors.neonCyan)
                }
            }
        }
    }

    private func summaryRow(title: String, value: String, highlight: Bool = false) -> some View {
        HStack {
            Text(title)
                .font(TelecomTypography.bodyMedium)
                .foregroundColor(TelecomColors.neutralMuted)
            Spacer()
            Text(value)
                .font(TelecomTypography.bodyBold)
                .foregroundColor(highlight ? TelecomColors.successGreen : .white)
        }
    }
}
