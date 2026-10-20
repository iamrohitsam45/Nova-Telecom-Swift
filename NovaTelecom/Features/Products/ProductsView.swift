import SwiftUI

public struct ProductsView: View {
    @StateObject private var viewModel = ProductsViewModel()
    @State private var showCartSheet = false

    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    public init() {}

    public var body: some View {
        NavigationStack {
            ZStack {
                TelecomColors.backgroundGradient.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Search Bar
                    HStack {
                        HStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(TelecomColors.neutralMuted)
                            TextField("Search routers, mesh, 5G hotspots, fiber...", text: $viewModel.searchText)
                                .foregroundColor(.white)
                                .autocorrectionDisabled()
                            if !viewModel.searchText.isEmpty {
                                Button(action: { viewModel.searchText = "" }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(TelecomColors.neutralMuted)
                                }
                            }
                        }
                        .padding(10)
                        .background(Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 14))

                        // Floating Cart Button
                        Button(action: {
                            HapticFeedback.light()
                            showCartSheet = true
                        }) {
                            ZStack {
                                Circle()
                                    .fill(TelecomColors.heroGradient)
                                    .frame(width: 44, height: 44)

                                Image(systemName: "cart.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))

                                let count = DemoDataStore.shared.cart.totalItemCount
                                if count > 0 {
                                    Text("\(count)")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(4)
                                        .background(TelecomColors.dangerRed)
                                        .clipShape(Circle())
                                        .offset(x: 12, y: -12)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)

                    // Category Filter Pills
                    ProductCategoryFilter(selectedCategory: $viewModel.selectedCategory)
                        .padding(.vertical, 8)

                    // Product Grid
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 14) {
                            ForEach(viewModel.filteredProducts) { product in
                                NavigationLink(destination: ProductDetails3DView(product: product)) {
                                    ProductCardView(
                                        product: product,
                                        isCompared: viewModel.comparedProductIds.contains(product.id),
                                        onAddToCart: {
                                            viewModel.addToCart(product: product)
                                        },
                                        onToggleCompare: {
                                            viewModel.toggleCompare(productId: product.id)
                                        }
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .padding(.bottom, 100) // Padding for Tab Bar and Floating Compare
                    }
                    .refreshable {
                        viewModel.loadProducts()
                    }
                }

                // Floating Comparison Bar
                if !viewModel.comparedProductIds.isEmpty {
                    VStack {
                        Spacer()
                        HStack {
                            Text("\(viewModel.comparedProductIds.count) products selected")
                                .font(TelecomTypography.bodyBold)
                                .foregroundColor(.white)

                            Spacer()

                            Button(action: {
                                HapticFeedback.medium()
                                viewModel.showCompareModal = true
                            }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "square.split.2x1")
                                    Text("Compare Now")
                                }
                                .font(TelecomTypography.captionMedium)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(TelecomColors.heroGradient)
                                .clipShape(Capsule())
                            }
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(TelecomColors.cardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(TelecomColors.neonCyan.opacity(0.5), lineWidth: 1)
                                )
                                .shadow(color: Color.black.opacity(0.4), radius: 12)
                        )
                        .padding(.horizontal, 16)
                        .padding(.bottom, 80)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }

                // Added to Cart Toast
                if let toast = viewModel.addedToCartToast {
                    VStack {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(TelecomColors.successGreen)
                            Text(toast)
                                .font(TelecomTypography.bodyBold)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.black.opacity(0.85))
                        .clipShape(Capsule())
                        .shadow(radius: 8)
                        .padding(.top, 16)

                        Spacer()
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation { viewModel.addedToCartToast = nil }
                        }
                    }
                }
            }
            .navigationTitle("Marketplace")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $viewModel.showCompareModal) {
                ProductCompareView(products: viewModel.comparedProducts)
            }
            .sheet(isPresented: $showCartSheet) {
                CartView()
            }
        }
    }
}
