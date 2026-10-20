import SwiftUI

public struct CheckoutView: View {
    @Environment(\.dismiss) private var dismiss
    public let onCheckoutComplete: () -> Void

    @State private var selectedPaymentMethod: String = "Apple Pay"
    @State private var street: String = "742 Evergreen Terrace, Suite 4B"
    @State private var city: String = "San Francisco"
    @State private var state: String = "CA"
    @State private var postalCode: String = "94107"
    @State private var isProcessing: Bool = false
    @State private var completedOrder: Order?

    private let paymentMethods = ["Apple Pay", "Credit Card (•• 4242)", "Add to Telecom Monthly Bill"]

    public init(onCheckoutComplete: @escaping () -> Void) {
        self.onCheckoutComplete = onCheckoutComplete
    }

    public var body: some View {
        NavigationStack {
            ZStack {
                TelecomColors.backgroundGradient.ignoresSafeArea()

                if let order = completedOrder {
                    OrderConfirmationView(order: order) {
                        onCheckoutComplete()
                        dismiss()
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Shipping Address Card
                            GlassCard(cornerRadius: 20, padding: 16) {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Image(systemName: "shippingbox.fill")
                                            .foregroundColor(TelecomColors.neonCyan)
                                        Text("DELIVERY ADDRESS")
                                            .font(TelecomTypography.badge)
                                            .foregroundColor(TelecomColors.neutralMuted)
                                        Spacer()
                                    }

                                    VStack(alignment: .leading, spacing: 6) {
                                        TextField("Street Address", text: $street)
                                            .padding(10)
                                            .background(Color.white.opacity(0.08))
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .foregroundColor(.white)

                                        HStack(spacing: 8) {
                                            TextField("City", text: $city)
                                                .padding(10)
                                                .background(Color.white.opacity(0.08))
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                .foregroundColor(.white)

                                            TextField("State", text: $state)
                                                .frame(width: 60)
                                                .padding(10)
                                                .background(Color.white.opacity(0.08))
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                .foregroundColor(.white)

                                            TextField("ZIP", text: $postalCode)
                                                .frame(width: 80)
                                                .padding(10)
                                                .background(Color.white.opacity(0.08))
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                            }

                            // Payment Method Card
                            GlassCard(cornerRadius: 20, padding: 16) {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Image(systemName: "creditcard.fill")
                                            .foregroundColor(TelecomColors.cyberViolet)
                                        Text("SELECT PAYMENT METHOD")
                                            .font(TelecomTypography.badge)
                                            .foregroundColor(TelecomColors.neutralMuted)
                                        Spacer()
                                    }

                                    ForEach(paymentMethods, id: \.self) { method in
                                        Button(action: {
                                            HapticFeedback.selection()
                                            selectedPaymentMethod = method
                                        }) {
                                            HStack {
                                                Image(systemName: selectedPaymentMethod == method ? "checkmark.circle.fill" : "circle")
                                                    .foregroundColor(selectedPaymentMethod == method ? TelecomColors.neonCyan : TelecomColors.neutralMuted)
                                                Text(method)
                                                    .font(TelecomTypography.bodyMedium)
                                                    .foregroundColor(.white)
                                                Spacer()
                                            }
                                            .padding(12)
                                            .background(Color.white.opacity(selectedPaymentMethod == method ? 0.1 : 0.04))
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                        }
                                    }
                                }
                            }

                            // Final Grand Total Display
                            GlassCard(cornerRadius: 18, padding: 16) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("AMOUNT TO PAY")
                                            .font(TelecomTypography.badge)
                                            .foregroundColor(TelecomColors.neutralMuted)
                                        Text(DemoDataStore.shared.cart.formattedGrandTotal)
                                            .font(TelecomTypography.heroLarge)
                                            .foregroundColor(TelecomColors.neonCyan)
                                    }
                                    Spacer()
                                    StatusBadge(text: "SECURE 256-BIT", type: .cyber)
                                }
                            }

                            // Confirm & Pay Button
                            TelecomButton(
                                title: selectedPaymentMethod == "Apple Pay" ? "Pay with Apple Pay" : "Authorize Payment",
                                icon: selectedPaymentMethod == "Apple Pay" ? "applelogo" : "checkmark.shield.fill",
                                style: .primary,
                                isLoading: isProcessing,
                                action: executeCheckout
                            )
                        }
                        .padding(16)
                    }
                }
            }
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    if completedOrder == nil {
                        Button("Cancel") { dismiss() }
                            .foregroundColor(TelecomColors.neonCyan)
                    }
                }
            }
        }
    }

    private func executeCheckout() {
        isProcessing = true
        HapticFeedback.medium()

        Task {
            try? await Task.sleep(nanoseconds: 1_200_000_000)
            let address = Address(
                street: street,
                city: city,
                state: state,
                postalCode: postalCode
            )
            let newOrder = DemoDataStore.shared.placeOrder(address: address)
            self.completedOrder = newOrder
            self.isProcessing = false
            HapticFeedback.success()
        }
    }
}
