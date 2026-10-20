import SwiftUI
import Combine

@MainActor
public final class HomeViewModel: ObservableObject {
    @Published public var broadbandConnection: BroadbandConnection?
    @Published public var primarySIM: SIMCard?
    @Published public var dthAccount: DTHAccount?
    @Published public var subscriptions: [StreamingSubscription] = []
    @Published public var featuredProducts: [Product] = []
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?

    // Active Service Request indicator
    @Published public var activeTicket: SupportTicket?

    // Navigation and Modal State
    @Published public var show3DModemModal: Bool = false
    @Published public var showRechargeSheet: Bool = false
    @Published public var showSpeedUpgradeSheet: Bool = false
    @Published public var showBillPaySheet: Bool = false
    @Published public var showNotificationsSheet: Bool = false

    public init() {
        loadDashboardData()
    }

    public func loadDashboardData() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                async let broadbandsTask: [BroadbandConnection] = APIClient.shared.request(endpoint: .getBroadbandConnections)
                async let simsTask: [SIMCard] = APIClient.shared.request(endpoint: .getSimCards)
                async let dthListTask: [DTHAccount] = APIClient.shared.request(endpoint: .getDTHAccounts)
                async let subsTask: [StreamingSubscription] = APIClient.shared.request(endpoint: .getSubscriptions)
                async let prodsTask: [Product] = APIClient.shared.request(endpoint: .getProducts(category: nil, query: nil))
                async let ticketsTask: [SupportTicket] = APIClient.shared.request(endpoint: .getTickets)

                let (broadbands, sims, dthList, subs, prods, tickets) = try await (
                    broadbandsTask, simsTask, dthListTask, subsTask, prodsTask, ticketsTask
                )

                self.broadbandConnection = broadbands.first
                self.primarySIM = sims.first
                self.dthAccount = dthList.first
                self.subscriptions = subs
                self.featuredProducts = Array(prods.prefix(4))
                self.activeTicket = tickets.first(where: { $0.status == .inProgress || $0.status == .open })
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }

    public func refresh() async {
        HapticFeedback.light()
        loadDashboardData()
    }
}
