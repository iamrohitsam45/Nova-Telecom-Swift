import SwiftUI

public struct ProductDetails3DView: View {
    public let product: Product

    @State private var quantity: Int = 1
    @State private var selectedColorVariant: String = "Cyber Black"
    @State private var isWishlisted: Bool = false
    @State private var connectionState: ConnectionState = .online
    @State private var cameraPerspective: CameraPerspective = .isometric
    @State private var showAddedToast: Bool = false

    private let colorVariants = ["Cyber Black", "Titanium Grey", "Polar White"]

    public init(product: Product) {
        self.product = product
    }

    public var body: some View {
        ZStack {
            TelecomColors.backgroundGradient.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 1. Interactive 3D Model Stage or Fallback
                    interactive3DStage

                    VStack(alignment: .leading, spacing: 18) {
                        // 2. Title, Brand, Rating Row
                        headerSection

                        // 3. Price & Stock Row
                        pricingSection

                        // 4. Color Variant Selector
                        colorVariantsSection

                        // 5. Quantity & Add to Cart
                        purchaseControlsSection

                        Divider().background(Color.white.opacity(0.12))

                        // 6. Wi-Fi & Optical Telecom Hardware Specs
                        telecomSpecsSection

                        // 7. Full Technical Specifications Table
                        specificationsTableSection

                        // 8. Delivery, Warranty & 30-Day Return Policy
                        policySection

                        // 9. Customer Reviews & Ratings
                        reviewsSection
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 90)
                }
            }

            // Added to Cart Toast
            if showAddedToast {
                VStack {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(TelecomColors.successGreen)
                        Text("Added \(quantity)x \(product.name) to Cart")
                            .font(TelecomTypography.bodyBold)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 12)
                    .background(Color.black.opacity(0.9))
                    .clipShape(Capsule())
                    .shadow(radius: 10)
                    .padding(.top, 16)

                    Spacer()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation { showAddedToast = false }
                    }
                }
            }
        }
        .navigationTitle(product.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    HapticFeedback.light()
                    isWishlisted.toggle()
                }) {
                    Image(systemName: isWishlisted ? "heart.fill" : "heart")
                        .foregroundColor(isWishlisted ? TelecomColors.dangerRed : .white)
                }
            }
        }
    }

    // MARK: - Interactive 3D Stage
    private var interactive3DStage: some View {
        ZStack(alignment: .topTrailing) {
            if product.model3DAsset != nil || product.category == .wifiRouters || product.category == .meshWifi {
                VStack(spacing: 0) {
                    RouterSceneView(
                        connectionState: $connectionState,
                        currentPerspective: $cameraPerspective
                    )
                    .frame(height: 320)
                }
                .background(TelecomColors.deepNavy)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                )
            } else {
                // Static Fallback View
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white.opacity(0.04))
                        .frame(height: 260)

                    Image(systemName: product.category.iconName)
                        .font(.system(size: 80))
                        .foregroundColor(TelecomColors.neonCyan)
                }
            }

            // 3D Badge Indicator
            HStack(spacing: 4) {
                Image(systemName: "rotate.3d")
                Text("360° Interactive")
            }
            .font(TelecomTypography.badge)
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.black.opacity(0.6))
            .clipShape(Capsule())
            .padding(14)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(product.brand.uppercased())
                    .font(TelecomTypography.captionMedium)
                    .fontWeight(.bold)
                    .foregroundColor(TelecomColors.neonCyan)
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 13))
                    Text(String(format: "%.1f", product.rating))
                        .font(TelecomTypography.bodyBold)
                        .foregroundColor(.white)
                    Text("(\(product.reviewCount) reviews)")
                        .font(TelecomTypography.captionSmall)
                        .foregroundColor(TelecomColors.neutralMuted)
                }
            }

            Text(product.name)
                .font(TelecomTypography.titleLarge)
                .foregroundColor(.white)

            Text(product.headline)
                .font(TelecomTypography.bodyMedium)
                .foregroundColor(TelecomColors.neutralMuted)
        }
    }

    // MARK: - Pricing Section
    private var pricingSection: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(product.formattedPrice)
                .font(TelecomTypography.heroLarge)
                .foregroundColor(TelecomColors.neonCyan)

            if let original = product.formattedOriginalPrice {
                Text(original)
                    .font(TelecomTypography.titleMedium)
                    .strikethrough()
                    .foregroundColor(TelecomColors.neutralMuted)
                    .padding(.leading, 6)
            }

            Spacer()

            StatusBadge(
                text: product.inStock ? "IN STOCK (\(product.stockCount))" : "OUT OF STOCK",
                type: product.inStock ? .active : .error
            )
        }
    }

    // MARK: - Color Variants
    private var colorVariantsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("FINISH / COLOR")
                .font(TelecomTypography.badge)
                .foregroundColor(TelecomColors.neutralMuted)

            HStack(spacing: 12) {
                ForEach(colorVariants, id: \.self) { color in
                    Button(action: {
                        HapticFeedback.selection()
                        selectedColorVariant = color
                    }) {
                        Text(color)
                            .font(TelecomTypography.captionMedium)
                            .fontWeight(selectedColorVariant == color ? .bold : .regular)
                            .foregroundColor(selectedColorVariant == color ? .white : TelecomColors.neutralMuted)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                selectedColorVariant == color
                                ? TelecomColors.electricBlue
                                : Color.white.opacity(0.06)
                            )
                            .clipShape(Capsule())
                    }
                }
            }
        }
    }

    // MARK: - Purchase Controls
    private var purchaseControlsSection: some View {
        HStack(spacing: 14) {
            // Quantity Stepper
            HStack(spacing: 12) {
                Button(action: {
                    if quantity > 1 {
                        HapticFeedback.light()
                        quantity -= 1
                    }
                }) {
                    Image(systemName: "minus")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(quantity > 1 ? .white : TelecomColors.neutralMuted)
                }

                Text("\(quantity)")
                    .font(TelecomTypography.bodyBold)
                    .foregroundColor(.white)
                    .frame(minWidth: 20)

                Button(action: {
                    if quantity < product.stockCount {
                        HapticFeedback.light()
                        quantity += 1
                    }
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color.white.opacity(0.08))
            .clipShape(Capsule())

            // Add to Cart Button
            TelecomButton(
                title: "Add to Cart",
                icon: "cart.badge.plus",
                style: .primary,
                action: {
                    DemoDataStore.shared.addToCart(product: product, quantity: quantity)
                    withAnimation { showAddedToast = true }
                }
            )
        }
    }

    // MARK: - Telecom Hardware Specs
    private var telecomSpecsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("TELECOM CAPABILITIES")
                .font(TelecomTypography.captionMedium)
                .foregroundColor(TelecomColors.neutralMuted)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                if let wifi = product.wifiGeneration {
                    specPill(icon: "wifi", title: "Standard", value: wifi)
                }
                if let speed = product.maxSpeedMbps {
                    specPill(icon: "speedometer", title: "Max Throughput", value: DataSizeFormatter.formatSpeed(mbps: speed))
                }
                specPill(icon: "shield.checkerboard", title: "Security", value: "WPA3 / Cyber Shield")
                specPill(icon: "shippingbox.fill", title: "Delivery", value: "\(product.deliveryDays) Days Express")
            }
        }
    }

    private func specPill(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(TelecomColors.neonCyan)
                .font(.system(size: 16))
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(TelecomTypography.captionSmall)
                    .foregroundColor(TelecomColors.neutralMuted)
                Text(value)
                    .font(TelecomTypography.captionMedium)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Specifications Table
    private var specificationsTableSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("TECHNICAL SPECIFICATIONS")
                .font(TelecomTypography.captionMedium)
                .foregroundColor(TelecomColors.neutralMuted)

            GlassCard(cornerRadius: 18, padding: 14) {
                VStack(spacing: 10) {
                    if !product.ports.isEmpty {
                        tableRow(label: "Interface Ports", value: product.ports.joined(separator: ", "))
                        Divider().background(Color.white.opacity(0.1))
                    }
                    if !product.bands.isEmpty {
                        tableRow(label: "Frequency Bands", value: product.bands.joined(separator: ", "))
                        Divider().background(Color.white.opacity(0.1))
                    }
                    ForEach(product.specifications) { spec in
                        tableRow(label: spec.key, value: spec.value)
                        Divider().background(Color.white.opacity(0.1))
                    }
                    tableRow(label: "Warranty Period", value: "\(product.warrantyMonths) Months Manufacturer")
                }
            }
        }
    }

    private func tableRow(label: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text(label)
                .font(TelecomTypography.captionMedium)
                .foregroundColor(TelecomColors.neutralMuted)
                .frame(width: 120, alignment: .leading)
            Text(value)
                .font(TelecomTypography.captionMedium)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    // MARK: - Policy Section
    private var policySection: some View {
        HStack(spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "shippingbox.fill")
                    .foregroundColor(TelecomColors.neonCyan)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Free Shipping")
                        .font(TelecomTypography.captionMedium)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("Orders over $100")
                        .font(TelecomTypography.captionSmall)
                        .foregroundColor(TelecomColors.neutralMuted)
                }
            }

            Divider().frame(height: 30).background(Color.white.opacity(0.15))

            HStack(spacing: 8) {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .foregroundColor(TelecomColors.cyberViolet)
                VStack(alignment: .leading, spacing: 2) {
                    Text("30-Day Returns")
                        .font(TelecomTypography.captionMedium)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("Hassle-free guarantee")
                        .font(TelecomTypography.captionSmall)
                        .foregroundColor(TelecomColors.neutralMuted)
                }
            }
        }
        .padding(14)
        .background(Color.white.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Reviews Section
    private var reviewsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("VERIFIED CUSTOMER REVIEWS")
                .font(TelecomTypography.captionMedium)
                .foregroundColor(TelecomColors.neutralMuted)

            if product.reviews.isEmpty {
                Text("No customer reviews yet. Be the first to leave a review!")
                    .font(TelecomTypography.captionMedium)
                    .foregroundColor(TelecomColors.neutralMuted)
            } else {
                ForEach(product.reviews) { rev in
                    GlassCard(cornerRadius: 16, padding: 12) {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(rev.authorName)
                                    .font(TelecomTypography.bodyBold)
                                    .foregroundColor(.white)
                                Spacer()
                                HStack(spacing: 2) {
                                    ForEach(0..<5) { star in
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 10))
                                            .foregroundColor(Double(star) < rev.rating ? .yellow : Color.white.opacity(0.2))
                                    }
                                }
                            }
                            Text(rev.comment)
                                .font(TelecomTypography.captionMedium)
                                .foregroundColor(.white.opacity(0.85))
                        }
                    }
                }
            }
        }
    }
}
