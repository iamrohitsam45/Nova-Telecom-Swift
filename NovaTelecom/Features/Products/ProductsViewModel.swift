import SwiftUI
import Combine

@MainActor
public final class ProductsViewModel: ObservableObject {
    @Published public var products: [Product] = []
    @Published public var selectedCategory: ProductCategory? = nil
    @Published public var searchText: String = ""
    @Published public var comparedProductIds: Set<String> = []
    @Published public var showCompareModal: Bool = false
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    @Published public var addedToCartToast: String?

    public init() {
        loadProducts()
    }

    public var filteredProducts: [Product] {
        var result = products
        if let cat = selectedCategory {
            result = result.filter { $0.category == cat }
        }
        if !searchText.isEmpty {
            let q = searchText.lowercased()
            result = result.filter {
                $0.name.lowercased().contains(q) ||
                $0.description.lowercased().contains(q) ||
                $0.brand.lowercased().contains(q)
            }
        }
        return result
    }

    public var comparedProducts: [Product] {
        products.filter { comparedProductIds.contains($0.id) }
    }

    public func loadProducts() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let items: [Product] = try await APIClient.shared.request(endpoint: .getProducts(category: selectedCategory, query: searchText.isEmpty ? nil : searchText))
                self.products = items
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }

    public func toggleCompare(productId: String) {
        if comparedProductIds.contains(productId) {
            comparedProductIds.remove(productId)
        } else {
            if comparedProductIds.count >= 3 {
                // Max 3 comparison
                return
            }
            comparedProductIds.insert(productId)
        }
    }

    public func addToCart(product: Product) {
        DemoDataStore.shared.addToCart(product: product)
        addedToCartToast = "Added \(product.name) to Cart"
    }
}
