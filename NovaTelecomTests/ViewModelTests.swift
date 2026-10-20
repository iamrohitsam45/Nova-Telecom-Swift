import XCTest
@testable import NovaTelecom

@MainActor
final class ViewModelTests: XCTestCase {
    func testProductsViewModelCategoryFilter() async {
        let vm = ProductsViewModel()
        // Wait for task
        try? await Task.sleep(nanoseconds: 300_000_000)

        XCTAssertFalse(vm.products.isEmpty)

        vm.selectedCategory = .wifiRouters
        for product in vm.filteredProducts {
            XCTAssertEqual(product.category, .wifiRouters)
        }

        vm.selectedCategory = .meshWifi
        for product in vm.filteredProducts {
            XCTAssertEqual(product.category, .meshWifi)
        }
    }

    func testProductsViewModelSearch() async {
        let vm = ProductsViewModel()
        try? await Task.sleep(nanoseconds: 300_000_000)

        vm.searchText = "Cat 8"
        XCTAssertEqual(vm.filteredProducts.count, 1)
        XCTAssertEqual(vm.filteredProducts.first?.id, "prod_cat8_cable")
    }

    func testProductComparisonToggle() async {
        let vm = ProductsViewModel()
        try? await Task.sleep(nanoseconds: 300_000_000)

        XCTAssertTrue(vm.comparedProductIds.isEmpty)

        vm.toggleCompare(productId: "prod_router_pro7")
        XCTAssertTrue(vm.comparedProductIds.contains("prod_router_pro7"))

        vm.toggleCompare(productId: "prod_mesh_orbit3")
        XCTAssertEqual(vm.comparedProductIds.count, 2)

        vm.toggleCompare(productId: "prod_router_pro7")
        XCTAssertFalse(vm.comparedProductIds.contains("prod_router_pro7"))
        XCTAssertEqual(vm.comparedProductIds.count, 1)
    }

    func testSupportViewModelSearch() async {
        let vm = SupportViewModel()
        try? await Task.sleep(nanoseconds: 500_000_000)

        vm.searchQuery = "LED"
        XCTAssertFalse(vm.filteredFAQs.isEmpty)
        for faq in vm.filteredFAQs {
            XCTAssertTrue(faq.question.contains("LED") || faq.answer.contains("LED"))
        }
    }
}
