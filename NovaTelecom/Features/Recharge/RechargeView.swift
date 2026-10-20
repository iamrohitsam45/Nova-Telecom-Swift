import SwiftUI

public struct RechargeView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedSimIndex: Int = 0
    @State private var selectedAmountMinorUnits: Int = 2999
    @State private var customAmountText: String = ""
    @State private var isAutoRenewEnabled: Bool = true
    @State private var isProcessing: Bool = false
    @State private var isSuccess: Bool = false

    private let quickAmounts = [1000, 1999, 2999, 4999, 9999] // In cents ($10, $19.99, $29.99, $49.99, $99.99)
    private let sims = DemoDataStore.shared.simCards

    public init() {}

    public var body: some View {
        NavigationStack {
            ZStack {
                TelecomColors.backgroundGradient.ignoresSafeArea()

                if isSuccess {
                    successStateView
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Target SIM Card Selector
                            simSelectorCard

                            // Quick Amount Chips
                            amountSelectorCard

                            // Scheduled Reminder / Auto-Renew
                            autoRenewCard

                            // Recharge CTA
                            TelecomButton(
                                title: "Recharge \(CurrencyFormatter.format(minorUnits: selectedAmountMinorUnits)) with Apple Pay",
                                icon: "bolt.fill",
                                style: .primary,
                                isLoading: isProcessing,
                                action: executeRecharge
                            )
                        }
                        .padding(16)
                    }
                }
            }
            .navigationTitle("Mobile Recharge")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(TelecomColors.neonCyan)
                }
            }
        }
    }

    private var simSelectorCard: some View {
        GlassCard(cornerRadius: 20, padding: 16) {
            VStack(alignment: .leading, spacing: 12) {
                Text("RECHARGE TARGET MOBILE NUMBER")
                    .font(TelecomTypography.badge)
                    .foregroundColor(TelecomColors.neutralMuted)

                ForEach(0..<sims.count, id: \.self) { idx in
                    let sim = sims[idx]
                    Button(action: {
                        HapticFeedback.selection()
                        selectedSimIndex = idx
                    }) {
                        HStack {
                            Image(systemName: selectedSimIndex == idx ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(selectedSimIndex == idx ? TelecomColors.neonCyan : TelecomColors.neutralMuted)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(sim.phoneNumber)
                                    .font(TelecomTypography.bodyBold)
                                    .foregroundColor(.white)
                                Text("Balance: \(sim.formattedBalance) • \(String(format: "%.1f", sim.dataRemainingGB)) GB Data Remaining")
                                    .font(TelecomTypography.captionSmall)
                                    .foregroundColor(TelecomColors.neutralMuted)
                            }

                            Spacer()

                            StatusBadge(text: sim.isEsim ? "eSIM" : "Physical", type: .cyber)
                        }
                        .padding(10)
                        .background(Color.white.opacity(selectedSimIndex == idx ? 0.08 : 0.02))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
        }
    }

    private var amountSelectorCard: some View {
        GlassCard(cornerRadius: 20, padding: 16) {
            VStack(alignment: .leading, spacing: 12) {
                Text("SELECT TOP-UP / RECHARGE AMOUNT")
                    .font(TelecomTypography.badge)
                    .foregroundColor(TelecomColors.neutralMuted)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(quickAmounts, id: \.self) { amount in
                        let isSelected = selectedAmountMinorUnits == amount

                        Button(action: {
                            HapticFeedback.selection()
                            selectedAmountMinorUnits = amount
                        }) {
                            Text(CurrencyFormatter.format(minorUnits: amount))
                                .font(TelecomTypography.bodyBold)
                                .foregroundColor(isSelected ? .white : TelecomColors.neutralMuted)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    isSelected
                                    ? TelecomColors.electricBlue
                                    : Color.white.opacity(0.06)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
            }
        }
    }

    private var autoRenewCard: some View {
        GlassCard(cornerRadius: 18, padding: 14) {
            Toggle(isOn: $isAutoRenewEnabled) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Auto-Recharge Reminder")
                        .font(TelecomTypography.bodyBold)
                        .foregroundColor(.white)
                    Text("Notify 3 days before validity expires to avoid service interruption")
                        .font(TelecomTypography.captionSmall)
                        .foregroundColor(TelecomColors.neutralMuted)
                }
            }
            .tint(TelecomColors.neonCyan)
        }
    }

    private var successStateView: some View {
        VStack(spacing: 20) {
            Spacer()

            ZStack {
                Circle()
                    .fill(TelecomColors.successGreen.opacity(0.18))
                    .frame(width: 80, height: 80)
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 56))
                    .foregroundColor(TelecomColors.successGreen)
            }

            Text("Recharge Successful!")
                .font(TelecomTypography.titleLarge)
                .foregroundColor(.white)

            Text("Your balance and 5G data have been credited instantly. Carrier trace ID: TX-SIM-\(Int.random(in: 100000...999999)).")
                .font(TelecomTypography.bodyMedium)
                .foregroundColor(TelecomColors.neutralMuted)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 28)

            Spacer()

            TelecomButton(
                title: "Done",
                icon: "checkmark",
                style: .primary,
                action: { dismiss() }
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
    }

    private func executeRecharge() {
        isProcessing = true
        HapticFeedback.medium()

        Task {
            try? await Task.sleep(nanoseconds: 900_000_000)
            let selectedSim = sims[selectedSimIndex]
            DemoDataStore.shared.rechargeSIM(
                simId: selectedSim.id,
                amountMinorUnits: selectedAmountMinorUnits,
                dataGB: 25.0
            )
            isProcessing = false
            isSuccess = true
            HapticFeedback.success()
        }
    }
}
