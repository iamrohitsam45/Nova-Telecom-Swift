import SwiftUI

public struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @ObservedObject private var userSession = UserSession.shared
    @Binding public var selectedTab: TelecomTab

    // 3D Modem Perspective & State
    @State private var connectionState: ConnectionState = .online
    @State private var cameraPerspective: CameraPerspective = .isometric

    public init(selectedTab: Binding<TelecomTab>) {
        self._selectedTab = selectedTab
    }

    public var body: some View {
        NavigationStack {
            ZStack {
                TelecomColors.backgroundGradient
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 22) {
                        // 1. Premium Welcome Header
                        welcomeHeader

                        // 2. Interactive 3D Modem Hero Element
                        hero3DModemCard

                        if viewModel.isLoading && viewModel.broadbandConnection == nil {
                            // Skeleton Loading Placeholders
                            skeletonDashboard
                        } else {
                            // 3. Current Broadband Status & Data Gauge Card
                            if let broadband = viewModel.broadbandConnection {
                                BroadbandStatusCard(
                                    connection: broadband,
                                    onUpgradeTapped: { viewModel.showSpeedUpgradeSheet = true },
                                    onCardTapped: { selectedTab = .plans }
                                )
                            }

                            // 4. Quick Actions Carousel
                            QuickActionGrid { action in
                                handleQuickAction(action)
                            }

                            // 5. Mobile 5G SIM Balance & Quota Card
                            if let sim = viewModel.primarySIM {
                                MobileSimCard(
                                    simCard: sim,
                                    onRechargeTapped: { viewModel.showRechargeSheet = true }
                                )
                            }

                            // 6. DTH & Streaming Subscriptions Card
                            if let dth = viewModel.dthAccount {
                                DTHStreamingCard(
                                    dthAccount: dth,
                                    subscriptions: viewModel.subscriptions,
                                    onManageTapped: { selectedTab = .plans }
                                )
                            }

                            // 7. Active Service Request / Outage Diagnostics
                            if let ticket = viewModel.activeTicket {
                                activeServiceRequestCard(ticket)
                            }

                            // 8. Recommended Offers Carousel
                            RecommendedOffersView { _ in
                                selectedTab = .plans
                            }

                            // 9. Recently Viewed Products
                            recentlyViewedProductsSection
                        }

                        // Bottom Spacer for Tab Bar clearance
                        Color.clear.frame(height: 80)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                }
                .refreshable {
                    await viewModel.refresh()
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $viewModel.show3DModemModal) {
                full3DModemModal
            }
            .sheet(isPresented: $viewModel.showRechargeSheet) {
                RechargeView()
            }
            .sheet(isPresented: $viewModel.showSpeedUpgradeSheet) {
                SpeedUpgradeView { newDown, newUp, planName in
                    viewModel.broadbandConnection?.downloadSpeedMbps = newDown
                    viewModel.broadbandConnection?.uploadSpeedMbps = newUp
                    viewModel.broadbandConnection?.planName = planName
                }
            }
            .sheet(isPresented: $viewModel.showNotificationsSheet) {
                notificationsModal
            }
        }
    }

    // MARK: - Welcome Header
    private var welcomeHeader: some View {
        HStack {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(TelecomColors.heroGradient)
                        .frame(width: 44, height: 44)

                    Text(userSession.currentUser?.fullName.prefix(1).uppercased() ?? "A")
                        .font(TelecomTypography.titleSmall)
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("WELCOME BACK")
                        .font(TelecomTypography.captionSmall)
                        .foregroundColor(TelecomColors.neutralMuted)
                    Text(userSession.currentUser?.fullName ?? "Alex Mercer")
                        .font(TelecomTypography.titleMedium)
                        .foregroundColor(.white)
                }
            }

            Spacer()

            // Notification Bell Button
            Button(action: {
                HapticFeedback.light()
                viewModel.showNotificationsSheet = true
            }) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.08))
                        .frame(width: 42, height: 42)

                    Image(systemName: "bell.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 16))

                    // Unread badge dot
                    Circle()
                        .fill(TelecomColors.neonCyan)
                        .frame(width: 8, height: 8)
                        .offset(x: 9, y: -9)
                }
            }
        }
    }

    // MARK: - Hero 3D Modem Card
    private var hero3DModemCard: some View {
        GlassCard(cornerRadius: 24, padding: 16, hasGlow: true) {
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 6) {
                            Circle()
                                .fill(TelecomColors.successGreen)
                                .frame(width: 8, height: 8)
                            Text("NOVA GATEWAY PRO • 3D HARDWARE")
                                .font(TelecomTypography.captionSmall)
                                .fontWeight(.bold)
                                .foregroundColor(TelecomColors.neonCyan)
                        }
                        Text("Wi-Fi 7 Tri-Band Optical Router")
                            .font(TelecomTypography.titleSmall)
                            .foregroundColor(.white)
                    }

                    Spacer()

                    Button(action: {
                        HapticFeedback.medium()
                        viewModel.show3DModemModal = true
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "cube.transparent")
                            Text("Full 3D")
                        }
                        .font(TelecomTypography.captionSmall)
                        .fontWeight(.bold)
                        .foregroundColor(TelecomColors.neonCyan)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(TelecomColors.neonCyan.opacity(0.14))
                        .clipShape(Capsule())
                    }
                }

                // Interactive 3D View Embedded
                ZStack {
                    RouterSceneView(
                        connectionState: $connectionState,
                        currentPerspective: $cameraPerspective
                    )
                    .frame(height: 240)
                    .clipShape(RoundedRectangle(cornerRadius: 18))

                    // Pulse Wi-Fi overlay icon at top corner
                    VStack {
                        HStack {
                            Spacer()
                            AnimatedWifiWaveView(isOnline: connectionState == .online)
                                .scaleEffect(0.55)
                                .frame(width: 60, height: 60)
                                .padding(8)
                        }
                        Spacer()
                    }
                }

                HStack {
                    Text("Drag to orbit 360° • Pinch to zoom • Tap pins for port specs")
                        .font(TelecomTypography.captionSmall)
                        .foregroundColor(TelecomColors.neutralMuted)
                    Spacer()
                }
            }
        }
    }

    // MARK: - Active Service Request Card
    private func activeServiceRequestCard(_ ticket: SupportTicket) -> some View {
        GlassCard(cornerRadius: 18, padding: 14) {
            HStack(spacing: 12) {
                Image(systemName: "antenna.radiowaves.left.and.right")
                    .foregroundColor(TelecomColors.warningAmber)
                    .font(.system(size: 22))

                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text("ACTIVE SERVICE TRACE")
                            .font(TelecomTypography.badge)
                            .foregroundColor(TelecomColors.warningAmber)
                        Spacer()
                        Text(ticket.ticketNumber)
                            .font(TelecomTypography.captionSmall)
                            .foregroundColor(TelecomColors.neutralMuted)
                    }

                    Text(ticket.title)
                        .font(TelecomTypography.bodyBold)
                        .foregroundColor(.white)

                    Text(ticket.messages.last?.message ?? "Line calibration in progress")
                        .font(TelecomTypography.captionSmall)
                        .foregroundColor(TelecomColors.neutralMuted)
                        .lineLimit(1)
                }

                Spacer()

                Button(action: {
                    selectedTab = .support
                }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(TelecomColors.neutralMuted)
                }
            }
        }
    }

    // MARK: - Recently Viewed Products
    private var recentlyViewedProductsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("RECOMMENDED HARDWARE")
                    .font(TelecomTypography.captionMedium)
                    .foregroundColor(TelecomColors.neutralMuted)
                Spacer()
                Button(action: { selectedTab = .products }) {
                    Text("View Marketplace")
                        .font(TelecomTypography.captionSmall)
                        .foregroundColor(TelecomColors.neonCyan)
                }
            }
            .padding(.horizontal, 4)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(viewModel.featuredProducts) { product in
                        NavigationLink(destination: ProductDetails3DView(product: product)) {
                            VStack(alignment: .leading, spacing: 8) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(Color.white.opacity(0.06))
                                        .frame(height: 110)

                                    Image(systemName: product.category.iconName)
                                        .font(.system(size: 44))
                                        .foregroundColor(TelecomColors.neonCyan)
                                }

                                Text(product.name)
                                    .font(TelecomTypography.bodyBold)
                                    .foregroundColor(.white)
                                    .lineLimit(1)

                                Text(product.formattedPrice)
                                    .font(TelecomTypography.bodyBold)
                                    .foregroundColor(TelecomColors.neonCyan)
                            }
                            .frame(width: 160)
                            .padding(12)
                            .background(TelecomColors.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                        }
                        .buttonStyle(ScaleBounceButtonStyle())
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }

    // MARK: - Skeleton Dashboard
    private var skeletonDashboard: some View {
        VStack(spacing: 16) {
            SkeletonBox(height: 180, cornerRadius: 22)
            HStack(spacing: 12) {
                ForEach(0..<4) { _ in
                    SkeletonBox(height: 80, cornerRadius: 16)
                }
            }
            SkeletonBox(height: 140, cornerRadius: 20)
        }
    }

    // MARK: - Fullscreen 3D Modem Modal
    private var full3DModemModal: some View {
        NavigationStack {
            ZStack {
                TelecomColors.deepNavy.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Controls Bar
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Nova WiFi 7 Mesh Gateway Pro")
                                .font(TelecomTypography.titleSmall)
                                .foregroundColor(.white)
                            Text("Interactive Hardware Inspector")
                                .font(TelecomTypography.captionSmall)
                                .foregroundColor(TelecomColors.neonCyan)
                        }

                        Spacer()

                        Picker("Connection State", selection: $connectionState) {
                            Text("Online").tag(ConnectionState.online)
                            Text("Weak Signal").tag(ConnectionState.weakSignal)
                            Text("Offline").tag(ConnectionState.offline)
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 220)
                    }
                    .padding()
                    .background(Color.black.opacity(0.5))

                    RouterSceneView(
                        connectionState: $connectionState,
                        currentPerspective: $cameraPerspective
                    )
                }
            }
            .navigationTitle("3D Hardware Inspection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        viewModel.show3DModemModal = false
                    }
                    .foregroundColor(TelecomColors.neonCyan)
                }
            }
        }
    }

    // MARK: - Notifications Modal
    private var notificationsModal: some View {
        NavigationStack {
            ZStack {
                TelecomColors.backgroundGradient.ignoresSafeArea()

                List {
                    Section("Recent Updates") {
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "creditcard.fill")
                                .foregroundColor(TelecomColors.successGreen)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Monthly Statement Ready")
                                    .font(TelecomTypography.bodyBold)
                                    .foregroundColor(.white)
                                Text("Your statement for Gigabit Fiber 1000 ($79.99) is ready.")
                                    .font(TelecomTypography.captionSmall)
                                    .foregroundColor(TelecomColors.neutralMuted)
                            }
                        }
                        .listRowBackground(TelecomColors.cardBackground)

                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "wifi.router.fill")
                                .foregroundColor(TelecomColors.neonCyan)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Firmware Updated to 4.2.1")
                                    .font(TelecomTypography.bodyBold)
                                    .foregroundColor(.white)
                                Text("Optical transceiver stability and Wi-Fi 7 beamforming optimized.")
                                    .font(TelecomTypography.captionSmall)
                                    .foregroundColor(TelecomColors.neutralMuted)
                            }
                        }
                        .listRowBackground(TelecomColors.cardBackground)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        viewModel.showNotificationsSheet = false
                    }
                    .foregroundColor(TelecomColors.neonCyan)
                }
            }
        }
    }

    private func handleQuickAction(_ action: QuickActionType) {
        switch action {
        case .recharge:
            viewModel.showRechargeSheet = true
        case .payBill:
            selectedTab = .profile
        case .upgradeSpeed:
            viewModel.showSpeedUpgradeSheet = true
        case .buyModem:
            selectedTab = .products
        case .manageSIM:
            selectedTab = .plans
        }
    }
}
