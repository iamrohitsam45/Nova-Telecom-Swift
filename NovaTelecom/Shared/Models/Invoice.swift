import Foundation

public enum InvoiceStatus: String, Codable, Sendable {
    case paid = "PAID"
    case pending = "PENDING"
    case overdue = "OVERDUE"
}

public struct InvoiceLineItem: Identifiable, Codable, Equatable, Sendable {
    public let id: String
    public let description: String
    public let amountMinorUnits: Int

    public init(id: String = UUID().uuidString, description: String, amountMinorUnits: Int) {
        self.id = id
        self.description = description
        self.amountMinorUnits = amountMinorUnits
    }

    public var formattedAmount: String {
        return String(format: "$%.2f", Double(amountMinorUnits) / 100.0)
    }
}

public struct Invoice: Identifiable, Codable, Equatable, Sendable {
    public let id: String
    public let invoiceNumber: String // e.g. "INV-2026-10492"
    public let billingPeriodStart: Date
    public let billingPeriodEnd: Date
    public let dueDate: Date
    public let totalAmountMinorUnits: Int
    public var status: InvoiceStatus
    public let paymentMethod: String? // "Visa ending in 4242"
    public let lineItems: [InvoiceLineItem]
    public let pdfDownloadUrl: String?

    public init(
        id: String = UUID().uuidString,
        invoiceNumber: String,
        billingPeriodStart: Date,
        billingPeriodEnd: Date,
        dueDate: Date,
        totalAmountMinorUnits: Int,
        status: InvoiceStatus = .paid,
        paymentMethod: String? = "Apple Pay / Visa •• 4242",
        lineItems: [InvoiceLineItem] = [],
        pdfDownloadUrl: String? = nil
    ) {
        self.id = id
        self.invoiceNumber = invoiceNumber
        self.billingPeriodStart = billingPeriodStart
        self.billingPeriodEnd = billingPeriodEnd
        self.dueDate = dueDate
        self.totalAmountMinorUnits = totalAmountMinorUnits
        self.status = status
        self.paymentMethod = paymentMethod
        self.lineItems = lineItems
        self.pdfDownloadUrl = pdfDownloadUrl
    }

    public var formattedTotal: String {
        return String(format: "$%.2f", Double(totalAmountMinorUnits) / 100.0)
    }
}
