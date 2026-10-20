import Foundation

public struct SIMCard: Identifiable, Codable, Equatable, Sendable {
    public let id: String
    public let phoneNumber: String
    public let iccid: String
    public let isEsim: Bool
    public var balanceMinorUnits: Int // e.g. 1500 for $15.00
    public var dataRemainingGB: Double
    public var dataTotalGB: Double
    public var expiryDate: Date
    public var planName: String
    public var is5GActive: Bool
    public var status: String

    public init(
        id: String = UUID().uuidString,
        phoneNumber: String = "+1 (555) 392-8821",
        iccid: String = "8901410321111851072",
        isEsim: Bool = true,
        balanceMinorUnits: Int = 1850,
        dataRemainingGB: Double = 28.4,
        dataTotalGB: Double = 50.0,
        expiryDate: Date = Calendar.current.date(byAdding: .day, value: 18, to: Date()) ?? Date(),
        planName: String = "Ultra 5G Unlimited Max",
        is5GActive: Bool = true,
        status: String = "ACTIVE"
    ) {
        self.id = id
        self.phoneNumber = phoneNumber
        self.iccid = iccid
        self.isEsim = isEsim
        self.balanceMinorUnits = balanceMinorUnits
        self.dataRemainingGB = dataRemainingGB
        self.dataTotalGB = dataTotalGB
        self.expiryDate = expiryDate
        self.planName = planName
        self.is5GActive = is5GActive
        self.status = status
    }

    public var formattedBalance: String {
        return String(format: "$%.2f", Double(balanceMinorUnits) / 100.0)
    }
}

public struct BroadbandConnection: Identifiable, Codable, Equatable, Sendable {
    public let id: String
    public let serviceIdentifier: String // e.g. "NOVA-FIBER-8829"
    public var planName: String
    public var downloadSpeedMbps: Int
    public var uploadSpeedMbps: Int
    public var isOnline: Bool
    public var wifiSsid: String
    public var routerModel: String
    public var ipAddress: String
    public var dataUsedGB: Double
    public var dataTotalGB: Double // 0 = Unlimited
    public var billingCycleRenewDate: Date
    public var nextBillAmountMinorUnits: Int
    public var connectionState: ConnectionState

    public init(
        id: String = UUID().uuidString,
        serviceIdentifier: String = "NOVA-FIBER-9042",
        planName: String = "Gigabit Fiber Pro 1000",
        downloadSpeedMbps: Int = 1000,
        uploadSpeedMbps: Int = 1000,
        isOnline: Bool = true,
        wifiSsid: String = "NovaFiber_5G_Home",
        routerModel: String = "Nova WiFi 7 Mesh Gateway Pro",
        ipAddress: String = "192.168.1.1",
        dataUsedGB: Double = 412.8,
        dataTotalGB: Double = 1000.0,
        billingCycleRenewDate: Date = Calendar.current.date(byAdding: .day, value: 12, to: Date()) ?? Date(),
        nextBillAmountMinorUnits: Int = 7999,
        connectionState: ConnectionState = .online
    ) {
        self.id = id
        self.serviceIdentifier = serviceIdentifier
        self.planName = planName
        self.downloadSpeedMbps = downloadSpeedMbps
        self.uploadSpeedMbps = uploadSpeedMbps
        self.isOnline = isOnline
        self.wifiSsid = wifiSsid
        self.routerModel = routerModel
        self.ipAddress = ipAddress
        self.dataUsedGB = dataUsedGB
        self.dataTotalGB = dataTotalGB
        self.billingCycleRenewDate = billingCycleRenewDate
        self.nextBillAmountMinorUnits = nextBillAmountMinorUnits
        self.connectionState = connectionState
    }

    public var formattedNextBill: String {
        return String(format: "$%.2f", Double(nextBillAmountMinorUnits) / 100.0)
    }
}

public enum ConnectionState: String, Codable, Sendable {
    case online = "ONLINE"
    case connecting = "CONNECTING"
    case weakSignal = "WEAK_SIGNAL"
    case offline = "OFFLINE"
}

public struct DTHAccount: Identifiable, Codable, Equatable, Sendable {
    public let id: String
    public let subscriberNumber: String
    public let smartCardNumber: String
    public var packageName: String
    public var activeTillDate: Date
    public var monthlyFeeMinorUnits: Int
    public var totalChannels: Int
    public var isActive: Bool

    public init(
        id: String = UUID().uuidString,
        subscriberNumber: String = "DTH-984210",
        smartCardNumber: String = "4029-8812-7491",
        packageName: String = "Nova 4K Ultra Sports & Movies",
        activeTillDate: Date = Calendar.current.date(byAdding: .day, value: 24, to: Date()) ?? Date(),
        monthlyFeeMinorUnits: Int = 2499,
        totalChannels: Int = 380,
        isActive: Bool = true
    ) {
        self.id = id
        self.subscriberNumber = subscriberNumber
        self.smartCardNumber = smartCardNumber
        self.packageName = packageName
        self.activeTillDate = activeTillDate
        self.monthlyFeeMinorUnits = monthlyFeeMinorUnits
        self.totalChannels = totalChannels
        self.isActive = isActive
    }

    public var formattedFee: String {
        return String(format: "$%.2f", Double(monthlyFeeMinorUnits) / 100.0)
    }
}

public struct StreamingSubscription: Identifiable, Codable, Equatable, Sendable {
    public let id: String
    public let providerName: String // "Netflix Premium 4K", "Disney+ Bundle", "Prime Video"
    public let iconUrl: String
    public var isActivated: Bool
    public var renewalDate: Date
    public var tierDescription: String
    public var monthlyValueMinorUnits: Int

    public init(
        id: String = UUID().uuidString,
        providerName: String,
        iconUrl: String = "play.rectangle.fill",
        isActivated: Bool = true,
        renewalDate: Date = Calendar.current.date(byAdding: .day, value: 15, to: Date()) ?? Date(),
        tierDescription: String = "Included in Fiber Pro Plan",
        monthlyValueMinorUnits: Int = 1999
    ) {
        self.id = id
        self.providerName = providerName
        self.iconUrl = iconUrl
        self.isActivated = isActivated
        self.renewalDate = renewalDate
        self.tierDescription = tierDescription
        self.monthlyValueMinorUnits = monthlyValueMinorUnits
    }
}
