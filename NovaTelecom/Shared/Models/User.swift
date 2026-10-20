import Foundation

public struct User: Identifiable, Codable, Equatable, Sendable {
    public let id: String
    public let email: String
    public var fullName: String
    public var phoneNumber: String
    public var role: UserRole
    public var avatarUrl: String?
    public var customerSince: Date?
    public var primaryAddress: Address?

    public init(
        id: String,
        email: String,
        fullName: String,
        phoneNumber: String,
        role: UserRole = .customer,
        avatarUrl: String? = nil,
        customerSince: Date? = nil,
        primaryAddress: Address? = nil
    ) {
        self.id = id
        self.email = email
        self.fullName = fullName
        self.phoneNumber = phoneNumber
        self.role = role
        self.avatarUrl = avatarUrl
        self.customerSince = customerSince
        self.primaryAddress = primaryAddress
    }
}

public enum UserRole: String, Codable, Sendable {
    case customer = "CUSTOMER"
    case admin = "ADMIN"
    case supportAgent = "SUPPORT_AGENT"
}

public struct Address: Identifiable, Codable, Equatable, Sendable {
    public let id: String
    public var label: String // e.g. "Home", "Office"
    public var street: String
    public var apartment: String?
    public var city: String
    public var state: String
    public var postalCode: String
    public var country: String
    public var isDefault: Bool

    public init(
        id: String = UUID().uuidString,
        label: String = "Home",
        street: String,
        apartment: String? = nil,
        city: String,
        state: String,
        postalCode: String,
        country: String = "US",
        isDefault: Bool = false
    ) {
        self.id = id
        self.label = label
        self.street = street
        self.apartment = apartment
        self.city = city
        self.state = state
        self.postalCode = postalCode
        self.country = country
        self.isDefault = isDefault
    }

    public var formattedAddress: String {
        var result = street
        if let apt = apartment, !apt.isEmpty {
            result += ", \(apt)"
        }
        result += "\n\(city), \(state) \(postalCode)"
        return result
    }
}
