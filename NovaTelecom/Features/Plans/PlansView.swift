import SwiftUI

public struct PlansView: View {
    @StateObject private var viewModel = PlansViewModel()
    @State private var showRechargeConfirmation: Bool = false

    public init() {}

    public var body: some View {
        NavigationStack {
            ZStack {
                TelecomColors.backgroundGradient.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Category Sub-Tab Bar
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(PlanCategorySection.allCases) { section in
                                let isSelected = viewModel.selectedSection == section

                                Button(action: {
                                    HapticFeedback.light()
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        viewModel.selectedSection = section
                                    }
                                }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: section.icon)
                                            .font(.system(size: 13))
                                        Text(section.rawValue)
                                            .font(TelecomTypography.captionMedium)
                                            .fontWeight(isSelected ? .bold : .medium)
                                    }
                                    .foregroundColor(isSelected ? .white : TelecomColors.neutralMuted)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 10)
                                    .background(
                                        isSelected
                                        ? TelecomColors.electricBlue
                                        : Color.white.opacity(0.06)
                                    )
                                    .clipShape(Capsule())
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                    }

                    // Top Action Bar
                    HStack {
                        Button(action: {
                            HapticFeedback.light()
                            viewModel.showAvailabilityChecker = true
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "location.circle.fill")
                                Text("Check Coverage")
                            }
                            .font(TelecomTypography.captionSmall)
                            .foregroundColor(TelecomColors.neonCyan)
                        }

                        Spacer()

                        Button(action: {
                            HapticFeedback.light()
                            viewModel.showPlanComparison = true
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "square.split.2x1")
                                Text("Compare Plans")
                            }
                            .font(TelecomTypography.captionSmall)
                            .foregroundColor(TelecomColors.neonCyan)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 6)

                    // Scrollable Plan Content
                    ScrollView {
                        VStack(spacing: 16) {
                            switch viewModel.selectedSection {
                            case .mobile:
                                MobilePlansSubTab(plans: viewModel.plans) { plan in
                                    viewModel.selectedPlanForCheckout = plan
                                    showRechargeConfirmation = true
                                }
                            case .broadband:
                                BroadbandPlansSubTab(
                                    plans: viewModel.plans,
                                    onSelectPlan: { plan in
                                        viewModel.selectedPlanForCheckout = plan
                                        showRechargeConfirmation = true
                                    },
                                    onCheckAvailabilityTapped: {
                                        viewModel.showAvailabilityChecker = true
                                    }
                                )
                            case .dth:
                                DTHPlansSubTab(plans: viewModel.plans) { plan in
                                    viewModel.selectedPlanForCheckout = plan
                                    showRechargeConfirmation = true
                                }
                            case .streaming:
                                StreamingPlansSubTab(plans: viewModel.plans) { plan in
                                    viewModel.selectedPlanForCheckout = plan
                                    showRechargeConfirmation = true
                                }
                            }

                            Color.clear.frame(height: 80)
                        }
                    }
                    .refreshable {
                        viewModel.loadPlans()
                    }
                }
            }
            .navigationTitle("Telecom Plans")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $viewModel.showAvailabilityChecker) {
                AvailabilityCheckerView()
            }
            .sheet(isPresented: $viewModel.showPlanComparison) {
                PlanComparisonModal(plans: viewModel.plans.filter {
                    switch viewModel.selectedSection {
                    case .mobile: return $0.type == .mobilePrepaid || $0.type == .mobilePostpaid
                    case .broadband: return $0.type == .broadbandFiber
                    case .dth: return $0.type == .dthTelevision
                    case .streaming: return $0.type == .streamingOTT
                    }
                })
            }
            .sheet(isPresented: $showRechargeConfirmation) {
                if let plan = viewModel.selectedPlanForCheckout {
                    planCheckoutModal(plan)
                }
            }
        }
    }

    private func planCheckoutModal(_ plan: Plan) -> some View {
        NavigationStack {
            ZStack {
                TelecomColors.backgroundGradient.ignoresSafeArea()

                VStack(spacing: 20) {
                    GlassCard(cornerRadius: 20, padding: 18, hasGlow: true) {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("ORDER CONFIRMATION")
                                .font(TelecomTypography.badge)
                                .foregroundColor(TelecomColors.neonCyan)

                            Text(plan.name)
                                .font(TelecomTypography.titleLarge)
                                .foregroundColor(.white)

                            Text(plan.headline)
                                .font(TelecomTypography.bodyMedium)
                                .foregroundColor(TelecomColors.neutralMuted)

                            Divider().background(Color.white.opacity(0.12))

                            HStack {
                                Text("Total Amount")
                                    .font(TelecomTypography.bodyBold)
                                    .foregroundColor(.white)
                                Spacer()
                                Text(plan.formattedPrice)
                                    .font(TelecomTypography.titleLarge)
                                    .foregroundColor(TelecomColors.neonCyan)
                            }
                        }
                    }

                    TelecomButton(
                        title: "Confirm & Pay with Apple Pay",
                        icon: "applelogo",
                        style: .primary,
                        action: {
                            HapticFeedback.success()
                            showRechargeConfirmation = false
                        }
                    )

                    Spacer()
                }
                .padding(16)
            }
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { showRechargeConfirmation = false }
                        .foregroundColor(TelecomColors.neonCyan)
                }
            }
        }
    }
}
