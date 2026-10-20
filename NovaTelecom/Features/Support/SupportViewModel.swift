import SwiftUI
import Combine

@MainActor
public final class SupportViewModel: ObservableObject {
    @Published public var tickets: [SupportTicket] = []
    @Published public var faqs: [DemoDataStore.FAQItem] = []
    @Published public var searchQuery: String = ""
    @Published public var selectedCategory: String = "ALL"
    @Published public var isLoading: Bool = false
    @Published public var showTroubleshootingWizard: Bool = false
    @Published public var showCreateTicket: Bool = false

    public init() {
        loadData()
    }

    public var filteredFAQs: [DemoDataStore.FAQItem] {
        var result = faqs
        if selectedCategory != "ALL" {
            result = result.filter { $0.category == selectedCategory }
        }
        if !searchQuery.isEmpty {
            let q = searchQuery.lowercased()
            result = result.filter { $0.question.lowercased().contains(q) || $0.answer.lowercased().contains(q) }
        }
        return result
    }

    public func loadData() {
        isLoading = true
        Task {
            do {
                async let ticketsTask: [SupportTicket] = APIClient.shared.request(endpoint: .getTickets)
                async let faqsTask: [DemoDataStore.FAQItem] = APIClient.shared.request(endpoint: .getFAQs)

                let (items, faqList) = try await (ticketsTask, faqsTask)
                self.tickets = items
                self.faqs = faqList

                self.isLoading = false
            } catch {
                self.isLoading = false
            }
        }
    }
}
