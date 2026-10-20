import Foundation

public struct CartItem: Identifiable, Codable, Equatable, Sendable {
    public let id: String
    public let product: Product
    public var quantity: Int
    public var selectedColor: String?

    public init(id: String = UUID().uuidString, product: Product, quantity: Int = 1, selectedColor: String? = "Cyber Black") {
        self.id = id
        self.product = product
        self.quantity = quantity
        self.selectedColor = selectedColor
    }

    public var subtotalMinorUnits: Int {
        return product.effectivePriceMinorUnits * quantity
    }

    public var formattedSubtotal: String {
        return String(format: "$%.2f", Double(subtotalMinorUnits) / 100.0)
    }
}

public struct Cart: Codable, Equatable, Sendable {
    public var items: [CartItem]
    public var promoCode: String?
    public var promoDiscountMinorUnits: Int

    public init(items: [CartItem] = [], promoCode: String? = nil, promoDiscountMinorUnits: Int = 0) {
        self.items = items
        self.promoCode = promoCode
        self.promoDiscountMinorUnits = promoDiscountMinorUnits
    }

    public var itemsSubtotalMinorUnits: Int {
        items.reduce(0) { $0 + $1.subtotalMinorUnits }
    }

    public var estimatedTaxMinorUnits: Int {
        // ~8% estimated sales tax
        Int(Double(itemsSubtotalMinorUnits) * 0.08)
    }

    public var shippingMinorUnits: Int {
        itemsSubtotalMinorUnits > 10000 || items.isEmpty ? 0 : 999 // Free shipping over $100
    }

    public var grandTotalMinorUnits: Int {
        max(itemsSubtotalMinorUnits - promoDiscountMinorUnits + estimatedTaxMinorUnits + shippingMinorUnits, 0)
    }

    public var totalItemCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    public var formattedGrandTotal: String {
        return String(format: "$%.2f", Double(grandTotalMinorUnits) / 100.0)
    }
}
