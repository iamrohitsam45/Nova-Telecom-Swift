import Foundation

public struct ServiceAvailabilityResult: Identifiable, Codable, Equatable, Sendable {
    public let id: String
    public let addressSearched: String
    public let isFiberAvailable: Bool
    public let is5GHomeAvailable: Bool
    public let maxDownloadSpeedMbps: Int
    public let maxUploadSpeedMbps: Int
    public let technologyType: String // e.g. "XGS-PON 10Gbps Fiber"
    public let estimatedInstallationDays: Int
    public let eligiblePlanIds: [String]

    public init(
        id: String = UUID().uuidString,
        addressSearched: String,
        isFiberAvailable: Bool,
        is5GHomeAvailable: Bool,
        maxDownloadSpeedMbps: Int,
        maxUploadSpeedMbps: Int,
        technologyType: String,
        estimatedInstallationDays: Int = 2,
        eligiblePlanIds: [String] = []
    ) {
        self.id = id
        self.addressSearched = addressSearched
        self.isFiberAvailable = isFiberAvailable
        self.is5GHomeAvailable = is5GHomeAvailable
        self.maxDownloadSpeedMbps = maxDownloadSpeedMbps
        self.maxUploadSpeedMbps = maxUploadSpeedMbps
        self.technologyType = technologyType
        self.estimatedInstallationDays = estimatedInstallationDays
        self.eligiblePlanIds = eligiblePlanIds
    }
}
