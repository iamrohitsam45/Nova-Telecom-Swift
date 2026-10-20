import SwiftUI
import Combine

public enum PlanCategorySection: String, CaseIterable, Identifiable {
    case mobile = "Mobile 5G"
    case broadband = "Fiber Broadband"
    case dth = "DTH TV"
    case streaming = "OTT Subscriptions"

    public var id: String { rawValue }

    public var icon: String {
        switch self {
        case .mobile: return "simcard.2.fill"
        case .broadband: return "bolt.horizontal.fill"
        case .dth: return "tv.inset.filled"
        case .streaming: return "play.tv.fill"
        }
    }
}

@MainActor
public final class PlansViewModel: ObservableObject {
    @Published public var plans: [Plan] = []
    @Published public var selectedSection: PlanCategorySection = .broadband
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?

    // Modals
    @Published public var showAvailabilityChecker: Bool = false
    @Published public var showPlanComparison: Bool = false
    @Published public var selectedPlanForCheckout: Plan?

    public init() {
        loadPlans()
    }

    public func loadPlans() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let items: [Plan] = try await APIClient.shared.request(endpoint: .getPlans(type: nil))
                self.plans = items
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}
