import SwiftUI

public struct ProductCardView: View {
    public let product: Product
    public let isCompared: Bool
    public let onAddToCart: () -> Void
    public let onToggleCompare: () -> Void

    public init(
        product: Product,
        isCompared: Bool = false,
        onAddToCart: @escaping () -> Void,
        onToggleCompare: @escaping () -> Void
    ) {
        self.product = product
        self.isCompared = isCompared
        self.onAddToCart = onAddToCart
        self.onToggleCompare = onToggleCompare
    }

    public var body: some View {
        GlassCard(cornerRadius: 20, padding: 14) {
            VStack(alignment: .leading, spacing: 10) {
                // Header Image & Badges
                ZStack(alignment: .topTrailing) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(Color.white.opacity(0.05))
                            .frame(height: 130)

                        Image(systemName: product.category.iconName)
                            .font(.system(size: 52))
                            .foregroundColor(TelecomColors.neonCyan)
                            .shadow(color: TelecomColors.neonCyan.opacity(0.3), radius: 8)
                    }

                    // Compare Checkbox Badge
                    Button(action: {
                        HapticFeedback.selection()
                        onToggleCompare()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: isCompared ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 14))
                            Text("Compare")
                                .font(TelecomTypography.captionSmall)
                        }
                        .foregroundColor(isCompared ? TelecomColors.neonCyan : TelecomColors.neutralMuted)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.45))
                        .clipShape(Capsule())
                    }
                    .padding(8)
                }

                // Brand & Category
                HStack {
                    Text(product.brand.uppercased())
                        .font(TelecomTypography.badge)
                        .foregroundColor(TelecomColors.neutralMuted)

                    Spacer()

                    if let wifi = product.wifiGeneration {
                        Text(wifi)
                            .font(TelecomTypography.badge)
                            .foregroundColor(TelecomColors.cyberViolet)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(TelecomColors.cyberViolet.opacity(0.15))
                            .clipShape(Capsule())
                    }
                }

                // Product Name
                Text(product.name)
                    .font(TelecomTypography.bodyBold)
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .frame(height: 40, alignment: .topLeading)

                // Ratings & Reviews
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 11))
                    Text(String(format: "%.1f", product.rating))
                        .font(TelecomTypography.captionSmall)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("(\(product.reviewCount))")
                        .font(TelecomTypography.captionSmall)
                        .foregroundColor(TelecomColors.neutralMuted)
                }

                Spacer(minLength: 4)

                // Price and Add to Cart Row
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 2) {
                        if let original = product.formattedOriginalPrice {
                            Text(original)
                                .font(TelecomTypography.captionSmall)
                                .strikethrough()
                                .foregroundColor(TelecomColors.neutralMuted)
                        }
                        Text(product.formattedPrice)
                            .font(TelecomTypography.titleSmall)
                            .foregroundColor(TelecomColors.neonCyan)
                    }

                    Spacer()

                    Button(action: {
                        HapticFeedback.medium()
                        onAddToCart()
                    }) {
                        Image(systemName: "cart.badge.plus")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 38, height: 38)
                            .background(TelecomColors.heroGradient)
                            .clipShape(Circle())
                            .shadow(color: TelecomColors.electricBlue.opacity(0.4), radius: 6)
                    }
                    .buttonStyle(ScaleBounceButtonStyle())
                }
            }
        }
    }
}
