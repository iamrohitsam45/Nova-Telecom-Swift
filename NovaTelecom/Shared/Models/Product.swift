import Foundation

public enum ProductCategory: String, Codable, CaseIterable, Sendable {
    case wifiRouters = "WIFI_ROUTERS"
    case fiberONT = "FIBER_ONT"
    case meshWifi = "MESH_WIFI"
    case portableHotspot = "PORTABLE_HOTSPOT"
    case simAndEsim = "SIM_ESIM"
    case fiberEquipment = "FIBER_EQUIPMENT"
    case dthSetTopBox = "DTH_STB"
    case accessories = "ACCESSORIES"

    public var displayName: String {
        switch self {
        case .wifiRouters: return "Wi-Fi Routers"
        case .fiberONT: return "Fiber ONTs"
        case .meshWifi: return "Mesh Systems"
        case .portableHotspot: return "5G Hotspots"
        case .simAndEsim: return "SIM & eSIM"
        case .fiberEquipment: return "Fiber Gear"
        case .dthSetTopBox: return "DTH Boxes"
        case .accessories: return "Accessories"
        }
    }

    public var iconName: String {
        switch self {
        case .wifiRouters: return "wifi.router"
        case .fiberONT: return "cable.connector"
        case .meshWifi: return "network"
        case .portableHotspot: return "dot.radiowaves.left.and.right"
        case .simAndEsim: return "simcard"
        case .fiberEquipment: return "point.3.filled.connected.trianglepath.dotted"
        case .dthSetTopBox: return "tv"
        case .accessories: return "cable.coaxial"
        }
    }
}

public struct ProductSpecification: Identifiable, Codable, Equatable, Sendable {
    public let id: String
    public let key: String
    public let value: String

    public init(id: String = UUID().uuidString, key: String, value: String) {
        self.id = id
        self.key = key
        self.value = value
    }
}

public struct ProductReview: Identifiable, Codable, Equatable, Sendable {
    public let id: String
    public let authorName: String
    public let rating: Double
    public let comment: String
    public let date: Date

    public init(id: String = UUID().uuidString, authorName: String, rating: Double, comment: String, date: Date = Date()) {
        self.id = id
        self.authorName = authorName
        self.rating = rating
        self.comment = comment
        self.date = date
    }
}

public struct Product: Identifiable, Codable, Equatable, Sendable {
    public let id: String
    public let name: String
    public let brand: String
    public let category: ProductCategory
    public let headline: String
    public let description: String
    public let priceMinorUnits: Int // e.g. 19999 for $199.99
    public let discountMinorUnits: Int?
    public let currency: String
    public let inStock: Bool
    public let stockCount: Int
    public let rating: Double
    public let reviewCount: Int
    public let imageUrl: String
    public let model3DAsset: String? // e.g. "NovaRouterPro3D"
    public let isFeatured: Bool
    public let wifiGeneration: String? // "Wi-Fi 7", "Wi-Fi 6E"
    public let maxSpeedMbps: Int?
    public let ports: [String]
    public let bands: [String]
    public let warrantyMonths: Int
    public let deliveryDays: Int
    public let specifications: [ProductSpecification]
    public let reviews: [ProductReview]

    public init(
        id: String,
        name: String,
        brand: String,
        category: ProductCategory,
        headline: String,
        description: String,
        priceMinorUnits: Int,
        discountMinorUnits: Int? = nil,
        currency: String = "USD",
        inStock: Bool = true,
        stockCount: Int = 50,
        rating: Double = 4.8,
        reviewCount: Int = 124,
        imageUrl: String = "router_hero",
        model3DAsset: String? = "procedural_router",
        isFeatured: Bool = false,
        wifiGeneration: String? = "Wi-Fi 7",
        maxSpeedMbps: Int? = 9600,
        ports: [String] = ["1x 10Gbps WAN", "4x 2.5Gbps LAN", "1x SC/APC Fiber", "1x USB 3.2"],
        bands: [String] = ["2.4 GHz", "5.0 GHz", "6.0 GHz"],
        warrantyMonths: Int = 24,
        deliveryDays: Int = 2,
        specifications: [ProductSpecification] = [],
        reviews: [ProductReview] = []
    ) {
        self.id = id
        self.name = name
        self.brand = brand
        self.category = category
        self.headline = headline
        self.description = description
        self.priceMinorUnits = priceMinorUnits
        self.discountMinorUnits = discountMinorUnits
        self.currency = currency
        self.inStock = inStock
        self.stockCount = stockCount
        self.rating = rating
        self.reviewCount = reviewCount
        self.imageUrl = imageUrl
        self.model3DAsset = model3DAsset
        self.isFeatured = isFeatured
        self.wifiGeneration = wifiGeneration
        self.maxSpeedMbps = maxSpeedMbps
        self.ports = ports
        self.bands = bands
        self.warrantyMonths = warrantyMonths
        self.deliveryDays = deliveryDays
        self.specifications = specifications
        self.reviews = reviews
    }

    public var effectivePriceMinorUnits: Int {
        if let discount = discountMinorUnits {
            return max(priceMinorUnits - discount, 0)
        }
        return priceMinorUnits
    }

    public var formattedPrice: String {
        let amount = Double(effectivePriceMinorUnits) / 100.0
        return String(format: "$%.2f", amount)
    }

    public var formattedOriginalPrice: String? {
        guard let discount = discountMinorUnits, discount > 0 else { return nil }
        let amount = Double(priceMinorUnits) / 100.0
        return String(format: "$%.2f", amount)
    }
}
