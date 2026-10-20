import Foundation

public enum PlanType: String, Codable, CaseIterable, Sendable {
    case mobilePrepaid = "MOBILE_PREPAID"
    case mobilePostpaid = "MOBILE_POSTPAID"
    case broadbandFiber = "BROADBAND_FIBER"
    case dthTelevision = "DTH_TV"
    case streamingOTT = "STREAMING_OTT"

    public var displayName: String {
        switch self {
        case .mobilePrepaid: return "Prepaid 5G"
        case .mobilePostpaid: return "Postpaid 5G"
        case .broadbandFiber: return "Fiber Broadband"
        case .dthTelevision: return "DTH Television"
        case .streamingOTT: return "OTT Subscriptions"
        }
    }

    public var iconName: String {
        switch self {
        case .mobilePrepaid: return "simcard.2"
        case .mobilePostpaid: return "simcard.fill"
        case .broadbandFiber: return "bolt.horizontal.fill"
        case .dthTelevision: return "tv.inset.filled"
        case .streamingOTT: return "play.tv.fill"
        }
    }
}

public struct PlanFeature: Identifiable, Codable, Equatable, Sendable {
    public let id: String
    public let title: String
    public let isHighlighted: Bool

    public init(id: String = UUID().uuidString, title: String, isHighlighted: Bool = false) {
        self.id = id
        self.title = title
        self.isHighlighted = isHighlighted
    }
}

public struct Plan: Identifiable, Codable, Equatable, Sendable {
    public let id: String
    public let name: String
    public let type: PlanType
    public let headline: String
    public let priceMinorUnits: Int
    public let currency: String
    public let billingCycleDays: Int // e.g. 30, 84, 365
    public let downloadSpeedMbps: Int?
    public let uploadSpeedMbps: Int?
    public let dataQuotaGB: Double? // nil = unlimited
    public let isUnlimitedData: Bool
    public let callingAllowance: String? // "Unlimited Local & National", "500 mins"
    public let smsAllowance: String? // "100 SMS/day"
    public let routerIncluded: Bool
    public let installationFeeMinorUnits: Int?
    public let bundledOTTApps: [String] // e.g. ["Netflix 4K", "Disney+ Hotstar", "Prime Video"]
    public let dthChannelCount: Int? // e.g. 350
    public let hdChannelCount: Int? // e.g. 85
    public let features: [PlanFeature]
    public let isPopular: Bool
    public let isBestValue: Bool

    public init(
        id: String,
        name: String,
        type: PlanType,
        headline: String,
        priceMinorUnits: Int,
        currency: String = "USD",
        billingCycleDays: Int = 30,
        downloadSpeedMbps: Int? = nil,
        uploadSpeedMbps: Int? = nil,
        dataQuotaGB: Double? = nil,
        isUnlimitedData: Bool = false,
        callingAllowance: String? = nil,
        smsAllowance: String? = nil,
        routerIncluded: Bool = false,
        installationFeeMinorUnits: Int? = nil,
        bundledOTTApps: [String] = [],
        dthChannelCount: Int? = nil,
        hdChannelCount: Int? = nil,
        features: [PlanFeature] = [],
        isPopular: Bool = false,
        isBestValue: Bool = false
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.headline = headline
        self.priceMinorUnits = priceMinorUnits
        self.currency = currency
        self.billingCycleDays = billingCycleDays
        self.downloadSpeedMbps = downloadSpeedMbps
        self.uploadSpeedMbps = uploadSpeedMbps
        self.dataQuotaGB = dataQuotaGB
        self.isUnlimitedData = isUnlimitedData
        self.callingAllowance = callingAllowance
        self.smsAllowance = smsAllowance
        self.routerIncluded = routerIncluded
        self.installationFeeMinorUnits = installationFeeMinorUnits
        self.bundledOTTApps = bundledOTTApps
        self.dthChannelCount = dthChannelCount
        self.hdChannelCount = hdChannelCount
        self.features = features
        self.isPopular = isPopular
        self.isBestValue = isBestValue
    }

    public var formattedPrice: String {
        let amount = Double(priceMinorUnits) / 100.0
        return String(format: "$%.2f", amount)
    }

    public var validityDescription: String {
        if billingCycleDays == 1 { return "1 Day" }
        if billingCycleDays == 7 { return "1 Week" }
        if billingCycleDays == 28 || billingCycleDays == 30 { return "Monthly" }
        if billingCycleDays == 84 || billingCycleDays == 90 { return "3 Months" }
        if billingCycleDays == 365 { return "1 Year" }
        return "\(billingCycleDays) Days"
    }
}
