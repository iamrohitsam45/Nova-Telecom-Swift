import Foundation

public enum OrderStatus: String, Codable, Sendable {
    case processing = "PROCESSING"
    case shipped = "SHIPPED"
    case delivered = "DELIVERED"
    case cancelled = "CANCELLED"
}

public struct OrderItem: Identifiable, Codable, Equatable, Sendable {
    public let id: String
    public let productId: String
    public let productName: String
    public let quantity: Int
    public let unitPriceMinorUnits: Int

    public init(id: String = UUID().uuidString, productId: String, productName: String, quantity: Int, unitPriceMinorUnits: Int) {
        self.id = id
        self.productId = productId
        self.productName = productName
        self.quantity = quantity
        self.unitPriceMinorUnits = unitPriceMinorUnits
    }

    public var formattedTotal: String {
        return String(format: "$%.2f", Double(unitPriceMinorUnits * quantity) / 100.0)
    }
}

public struct Order: Identifiable, Codable, Equatable, Sendable {
    public let id: String
    public let orderNumber: String // e.g. "ORD-9284-881"
    public let createdAt: Date
    public var status: OrderStatus
    public let items: [OrderItem]
    public let totalAmountMinorUnits: Int
    public let shippingAddress: Address
    public var trackingNumber: String?
    public var estimatedDeliveryDate: Date?

    public init(
        id: String = UUID().uuidString,
        orderNumber: String,
        createdAt: Date = Date(),
        status: OrderStatus = .processing,
        items: [OrderItem],
        totalAmountMinorUnits: Int,
        shippingAddress: Address,
        trackingNumber: String? = nil,
        estimatedDeliveryDate: Date? = nil
    ) {
        self.id = id
        self.orderNumber = orderNumber
        self.createdAt = createdAt
        self.status = status
        self.items = items
        self.totalAmountMinorUnits = totalAmountMinorUnits
        self.shippingAddress = shippingAddress
        self.trackingNumber = trackingNumber
        self.estimatedDeliveryDate = estimatedDeliveryDate
    }

    public var formattedTotal: String {
        return String(format: "$%.2f", Double(totalAmountMinorUnits) / 100.0)
    }
}
