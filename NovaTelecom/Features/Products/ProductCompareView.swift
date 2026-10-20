import SwiftUI

public struct ProductCompareView: View {
    public let products: [Product]
    @Environment(\.dismiss) private var dismiss

    public init(products: [Product]) {
        self.products = products
    }

    public var body: some View {
        NavigationStack {
            ZStack {
                TelecomColors.backgroundGradient.ignoresSafeArea()

                if products.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "square.split.2x1")
                            .font(.system(size: 48))
                            .foregroundColor(TelecomColors.neutralMuted)
                        Text("No products selected for comparison.")
                            .font(TelecomTypography.titleSmall)
                            .foregroundColor(.white)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Product Headers Row
                            HStack(alignment: .top, spacing: 12) {
                                ForEach(products) { product in
                                    VStack(spacing: 8) {
                                        Image(systemName: product.category.iconName)
                                            .font(.system(size: 36))
                                            .foregroundColor(TelecomColors.neonCyan)
                                            .frame(height: 60)

                                        Text(product.name)
                                            .font(TelecomTypography.captionMedium)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.center)
                                            .lineLimit(2)

                                        Text(product.formattedPrice)
                                            .font(TelecomTypography.titleSmall)
                                            .foregroundColor(TelecomColors.neonCyan)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(12)
                                    .background(TelecomColors.cardBackground)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                }
                            }

                            // Spec Comparison Rows
                            GlassCard(cornerRadius: 18, padding: 16) {
                                VStack(spacing: 14) {
                                    compareRow(title: "Category", values: products.map { $0.category.displayName })
                                    Divider().background(Color.white.opacity(0.1))
                                    compareRow(title: "Wi-Fi Standard", values: products.map { $0.wifiGeneration ?? "N/A (Optical/Ethernet)" })
                                    Divider().background(Color.white.opacity(0.1))
                                    compareRow(title: "Max Speed", values: products.map { $0.maxSpeedMbps != nil ? DataSizeFormatter.formatSpeed(mbps: $0.maxSpeedMbps!) : "Carrier Speed" })
                                    Divider().background(Color.white.opacity(0.1))
                                    compareRow(title: "Warranty", values: products.map { "\($0.warrantyMonths) Months" })
                                    Divider().background(Color.white.opacity(0.1))
                                    compareRow(title: "Rating", values: products.map { "★ \(String(format: "%.1f", $0.rating)) (\($0.reviewCount))" })
                                }
                            }
                        }
                        .padding(16)
                    }
                }
            }
            .navigationTitle("Product Comparison")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                        .foregroundColor(TelecomColors.neonCyan)
                }
            }
        }
    }

    private func compareRow(title: String, values: [String]) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title.uppercased())
                .font(TelecomTypography.badge)
                .foregroundColor(TelecomColors.neutralMuted)

            HStack(spacing: 12) {
                ForEach(0..<values.count, id: \.self) { i in
                    Text(values[i])
                        .font(TelecomTypography.bodyMedium)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}
