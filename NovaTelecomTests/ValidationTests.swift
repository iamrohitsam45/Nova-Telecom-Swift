import XCTest
@testable import NovaTelecom

final class ValidationTests: XCTestCase {
    func testCurrencyFormatter() {
        XCTAssertEqual(CurrencyFormatter.format(minorUnits: 2999, currencyCode: "USD"), "$29.99")
        XCTAssertEqual(CurrencyFormatter.format(minorUnits: 10000, currencyCode: "USD"), "$100.00")
        XCTAssertEqual(CurrencyFormatter.formatCompact(minorUnits: 2500, currencyCode: "USD"), "$25")
        XCTAssertEqual(CurrencyFormatter.formatCompact(minorUnits: 2550, currencyCode: "USD"), "$25.50")
    }

    func testDataSizeFormatter() {
        XCTAssertEqual(DataSizeFormatter.formatSpeed(mbps: 300), "300 Mbps")
        XCTAssertEqual(DataSizeFormatter.formatSpeed(mbps: 1000), "1 Gbps")
        XCTAssertEqual(DataSizeFormatter.formatSpeed(mbps: 2500), "2.5 Gbps")
        XCTAssertEqual(DataSizeFormatter.formatData(gb: 50.0), "50.0 GB")
        XCTAssertEqual(DataSizeFormatter.formatData(gb: 1500.0), "1.5 TB")
    }

    func testProductEffectivePrice() {
        let p1 = Product(
            id: "p1",
            name: "Router",
            brand: "Nova",
            category: .wifiRouters,
            headline: "Fast",
            description: "Fast",
            priceMinorUnits: 20000,
            discountMinorUnits: 3000
        )
        XCTAssertEqual(p1.effectivePriceMinorUnits, 17000)
        XCTAssertEqual(p1.formattedPrice, "$170.00")
        XCTAssertEqual(p1.formattedOriginalPrice, "$200.00")

        let p2 = Product(
            id: "p2",
            name: "Cable",
            brand: "Nova",
            category: .accessories,
            headline: "Cable",
            description: "Cable",
            priceMinorUnits: 1500,
            discountMinorUnits: nil
        )
        XCTAssertEqual(p2.effectivePriceMinorUnits, 1500)
        XCTAssertNil(p2.formattedOriginalPrice)
    }
}
