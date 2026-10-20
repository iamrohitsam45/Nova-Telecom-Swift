import XCTest
@testable import NovaTelecom

final class APIClientTests: XCTestCase {
    func testDemoDataStoreProducts() async throws {
        let prods: [Product] = try await DemoDataStore.shared.handleDemoRequest(
            endpoint: .getProducts(category: nil, query: nil),
            body: nil
        )
        XCTAssertGreaterThanOrEqual(prods.count, 12)
        XCTAssertTrue(prods.contains(where: { $0.id == "prod_router_pro7" }))
    }

    func testDemoDataStorePlans() async throws {
        let plans: [Plan] = try await DemoDataStore.shared.handleDemoRequest(
            endpoint: .getPlans(type: nil),
            body: nil
        )
        XCTAssertGreaterThanOrEqual(plans.count, 12)
        XCTAssertTrue(plans.contains(where: { $0.type == .broadbandFiber }))
        XCTAssertTrue(plans.contains(where: { $0.type == .mobilePrepaid }))
    }

    func testDemoDataStoreBroadbandAndSIM() async throws {
        let conns: [BroadbandConnection] = try await DemoDataStore.shared.handleDemoRequest(
            endpoint: .getBroadbandConnections,
            body: nil
        )
        XCTAssertFalse(conns.isEmpty)
        XCTAssertEqual(conns.first?.serviceIdentifier, "NOVA-FIBER-9042")

        let sims: [SIMCard] = try await DemoDataStore.shared.handleDemoRequest(
            endpoint: .getSimCards,
            body: nil
        )
        XCTAssertFalse(sims.isEmpty)
        XCTAssertEqual(sims.first?.phoneNumber, "+1 (555) 392-8821")
    }

    func testDemoDataStoreRechargeAndUpgrade() async {
        let prevSpeed = DemoDataStore.shared.broadbandConnection.downloadSpeedMbps
        DemoDataStore.shared.upgradeBroadbandSpeed(newDownloadMbps: 2500, newUploadMbps: 2500, planName: "Nova Fiber 2.5G")
        XCTAssertEqual(DemoDataStore.shared.broadbandConnection.downloadSpeedMbps, 2500)

        // Restore
        DemoDataStore.shared.upgradeBroadbandSpeed(newDownloadMbps: prevSpeed, newUploadMbps: prevSpeed, planName: "Gigabit Fiber Pro 1000")
    }
}
