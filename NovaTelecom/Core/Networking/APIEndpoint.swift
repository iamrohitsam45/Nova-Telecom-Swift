import Foundation

public enum APIEndpoint: Sendable {
    // Auth
    case register
    case login
    case refreshToken
    case logout
    case currentUser
    case updateProfile

    // Products
    case getProducts(category: ProductCategory?, query: String?)
    case getProductDetails(id: String)
    case compareProducts(ids: [String])

    // Plans
    case getPlans(type: PlanType?)
    case getPlanDetails(id: String)
    case getTelecomAccounts
    case getSimCards
    case rechargeMobile
    case rechargeHistory
    case getBroadbandConnections
    case checkBroadbandAvailability
    case requestSpeedUpgrade
    case getDTHAccounts
    case getSubscriptions
    case activateSubscription(id: String)
    case cancelSubscription(id: String)

    // Shopping & Orders
    case getCart
    case addToCart
    case updateCartItem(id: String)
    case removeCartItem(id: String)
    case createOrder
    case getOrders
    case getOrderDetails(id: String)
    case cancelOrder(id: String)

    // Invoices & Payments
    case getInvoices
    case getInvoiceDetails(id: String)
    case checkoutPayment
    case getPaymentStatus(id: String)

    // Support
    case getFAQs
    case getTickets
    case createTicket
    case getTicketDetails(id: String)
    case sendTicketMessage(ticketId: String)

    // Notifications
    case getNotifications
    case markNotificationRead(id: String)

    public var path: String {
        switch self {
        case .register: return "/auth/register"
        case .login: return "/auth/login"
        case .refreshToken: return "/auth/refresh"
        case .logout: return "/auth/logout"
        case .currentUser, .updateProfile: return "/users/me"

        case .getProducts: return "/products"
        case .getProductDetails(let id): return "/products/\(id)"
        case .compareProducts: return "/products/compare"

        case .getPlans: return "/plans"
        case .getPlanDetails(let id): return "/plans/\(id)"
        case .getTelecomAccounts: return "/accounts"
        case .getSimCards: return "/sim-cards"
        case .rechargeMobile: return "/recharges"
        case .rechargeHistory: return "/recharges/history"
        case .getBroadbandConnections: return "/broadband/connections"
        case .checkBroadbandAvailability: return "/broadband/availability"
        case .requestSpeedUpgrade: return "/broadband/speed-upgrades"
        case .getDTHAccounts: return "/dth/accounts"
        case .getSubscriptions: return "/subscriptions"
        case .activateSubscription(let id): return "/subscriptions/\(id)/activate"
        case .cancelSubscription(let id): return "/subscriptions/\(id)/cancel"

        case .getCart: return "/cart"
        case .addToCart: return "/cart/items"
        case .updateCartItem(let id), .removeCartItem(let id): return "/cart/items/\(id)"
        case .createOrder, .getOrders: return "/orders"
        case .getOrderDetails(let id): return "/orders/\(id)"
        case .cancelOrder(let id): return "/orders/\(id)/cancel"

        case .getInvoices: return "/invoices"
        case .getInvoiceDetails(let id): return "/invoices/\(id)"
        case .checkoutPayment: return "/payments/checkout"
        case .getPaymentStatus(let id): return "/payments/\(id)"

        case .getFAQs: return "/support/faqs"
        case .getTickets, .createTicket: return "/support/tickets"
        case .getTicketDetails(let id): return "/support/tickets/\(id)"
        case .sendTicketMessage(let id): return "/support/tickets/\(id)/messages"

        case .getNotifications: return "/notifications"
        case .markNotificationRead(let id): return "/notifications/\(id)/read"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .register, .login, .refreshToken, .logout, .rechargeMobile,
             .checkBroadbandAvailability, .requestSpeedUpgrade, .activateSubscription,
             .cancelSubscription, .addToCart, .createOrder, .cancelOrder,
             .checkoutPayment, .createTicket, .sendTicketMessage:
            return .post
        case .updateProfile, .updateCartItem, .markNotificationRead:
            return .patch
        case .removeCartItem:
            return .delete
        default:
            return .get
        }
    }
}
