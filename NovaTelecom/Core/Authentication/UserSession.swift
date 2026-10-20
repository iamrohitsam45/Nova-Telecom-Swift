import Foundation
import Combine

@MainActor
public final class UserSession: ObservableObject {
    public static let shared = UserSession()

    @Published public var currentUser: User?
    @Published public var isAuthenticated: Bool = false
    @Published public var isDemoUser: Bool = true

    private init() {
        // Initialize with default demo session for immediate interactive app experience
        self.currentUser = User(
            id: "usr_demo_8921",
            email: "alex.mercer@novatelecom.io",
            fullName: "Alex Mercer",
            phoneNumber: "+1 (555) 392-8821",
            role: .customer,
            avatarUrl: nil,
            customerSince: Calendar.current.date(byAdding: .year, value: -2, to: Date()),
            primaryAddress: Address(
                street: "742 Evergreen Terrace",
                apartment: "Suite 4B",
                city: "San Francisco",
                state: "CA",
                postalCode: "94107",
                isDefault: true
            )
        )
        self.isAuthenticated = true
        self.isDemoUser = true
    }

    public func setAuthenticatedUser(_ user: User, isDemo: Bool = false) {
        self.currentUser = user
        self.isAuthenticated = true
        self.isDemoUser = isDemo
    }

    public func signOut() {
        TokenStorage.shared.clearTokens()
        self.currentUser = nil
        self.isAuthenticated = false
        self.isDemoUser = false
    }
}
