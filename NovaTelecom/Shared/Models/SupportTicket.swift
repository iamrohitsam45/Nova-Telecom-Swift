import Foundation

public enum TicketPriority: String, Codable, Sendable {
    case low = "LOW"
    case medium = "MEDIUM"
    case high = "HIGH"
    case urgent = "URGENT"

    public var displayName: String {
        switch self {
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        case .urgent: return "Urgent"
        }
    }
}

public enum TicketStatus: String, Codable, Sendable {
    case open = "OPEN"
    case inProgress = "IN_PROGRESS"
    case resolved = "RESOLVED"
    case closed = "CLOSED"

    public var displayName: String {
        switch self {
        case .open: return "Open"
        case .inProgress: return "In Progress"
        case .resolved: return "Resolved"
        case .closed: return "Closed"
        }
    }
}

public struct SupportMessage: Identifiable, Codable, Equatable, Sendable {
    public let id: String
    public let sender: String // "User" or "Agent" or "Nova AI Assistant"
    public let isFromUser: Bool
    public let message: String
    public let timestamp: Date
    public let attachmentUrl: String?

    public init(
        id: String = UUID().uuidString,
        sender: String,
        isFromUser: Bool,
        message: String,
        timestamp: Date = Date(),
        attachmentUrl: String? = nil
    ) {
        self.id = id
        self.sender = sender
        self.isFromUser = isFromUser
        self.message = message
        self.timestamp = timestamp
        self.attachmentUrl = attachmentUrl
    }
}

public struct SupportTicket: Identifiable, Codable, Equatable, Sendable {
    public let id: String
    public let ticketNumber: String // e.g. "TCK-8491-01"
    public var title: String
    public var category: String // "Broadband Outage", "Slow Speed", "Billing", "Hardware"
    public var priority: TicketPriority
    public var status: TicketStatus
    public var createdAt: Date
    public var updatedAt: Date
    public var messages: [SupportMessage]
    public var scheduledAppointment: Date?

    public init(
        id: String = UUID().uuidString,
        ticketNumber: String,
        title: String,
        category: String,
        priority: TicketPriority = .medium,
        status: TicketStatus = .open,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        messages: [SupportMessage] = [],
        scheduledAppointment: Date? = nil
    ) {
        self.id = id
        self.ticketNumber = ticketNumber
        self.title = title
        self.category = category
        self.priority = priority
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.messages = messages
        self.scheduledAppointment = scheduledAppointment
    }
}
