import XCTest
@testable import NovaTelecom

final class CartPricingTests: XCTestCase {
    func testEmptyCartTotals() {
        let cart = Cart()
        XCTAssertEqual(cart.itemsSubtotalMinorUnits, 0)
        XCTAssertEqual(cart.estimatedTaxMinorUnits, 0)
        XCTAssertEqual(cart.shippingMinorUnits, 0)
        XCTAssertEqual(cart.grandTotalMinorUnits, 0)
    }

    func testCartSubtotalAndShippingUnderThreshold() {
        let cable = Product(
            id: "prod_cable",
            name: "Cat 8 Cable",
            brand: "NovaTech",
            category: .accessories,
            headline: "Ethernet",
            description: "Cable",
            priceMinorUnits: 2499 // $24.99
        )

        var cart = Cart()
        cart.items.append(CartItem(product: cable, quantity: 2)) // $49.98 = 4998

        XCTAssertEqual(cart.itemsSubtotalMinorUnits, 4998)
        XCTAssertEqual(cart.shippingMinorUnits, 999) // $9.99 shipping because under $100
        XCTAssertEqual(cart.estimatedTaxMinorUnits, 399) // 8% of 4998 = ~399
        XCTAssertEqual(cart.grandTotalMinorUnits, 4998 + 999 + 399)
    }

    func testCartFreeShippingOverThreshold() {
        let router = Product(
            id: "prod_router",
            name: "WiFi 7 Gateway",
            brand: "NovaTech",
            category: .wifiRouters,
            headline: "Router",
            description: "High speed",
            priceMinorUnits: 29999 // $299.99
        )

        var cart = Cart()
        cart.items.append(CartItem(product: router, quantity: 1))

        XCTAssertEqual(cart.itemsSubtotalMinorUnits, 29999)
        XCTAssertEqual(cart.shippingMinorUnits, 0) // Over $100 -> Free shipping!
    }

    func testCartDiscountCodeApplication() {
        let router = Product(
            id: "prod_router",
            name: "WiFi 7 Gateway",
            brand: "NovaTech",
            category: .wifiRouters,
            headline: "Router",
            description: "High speed",
            priceMinorUnits: 20000 // $200.00
        )

        var cart = Cart(items: [CartItem(product: router, quantity: 1)], promoCode: "NOVA50", promoDiscountMinorUnits: 5000)

        XCTAssertEqual(cart.itemsSubtotalMinorUnits, 20000)
        XCTAssertEqual(cart.promoDiscountMinorUnits, 5000)
        XCTAssertEqual(cart.estimatedTaxMinorUnits, 1600) // 8% of 20000 = 1600
        XCTAssertEqual(cart.shippingMinorUnits, 0)
        XCTAssertEqual(cart.grandTotalMinorUnits, 20000 - 5000 + 1600) // 16600 ($166.00)
    }
}
