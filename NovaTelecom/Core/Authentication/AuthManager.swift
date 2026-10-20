import Foundation

public struct AuthResponse: Codable, Sendable {
    public let user: User
    public let accessToken: String
    public let refreshToken: String
}

@MainActor
public final class AuthManager: ObservableObject {
    public static let shared = AuthManager()

    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?

    private init() {}

    public func signIn(email: String, password: String) async -> Bool {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        // In demo simulation mode or offline
        if NetworkConfiguration.shared.isDemoMode {
            try? await Task.sleep(nanoseconds: 500_000_000)
            let demoUser = User(
                id: "usr_alex_881",
                email: email.isEmpty ? "alex.mercer@novatelecom.io" : email,
                fullName: "Alex Mercer",
                phoneNumber: "+1 (555) 392-8821",
                role: .customer,
                customerSince: Date()
            )
            TokenStorage.shared.accessToken = "demo_access_token_jwt"
            TokenStorage.shared.refreshToken = "demo_refresh_token_jwt"
            UserSession.shared.setAuthenticatedUser(demoUser, isDemo: true)
            return true
        }

        // Live API integration
        do {
            let body = ["email": email, "password": password]
            let response: AuthResponse = try await APIClient.shared.request(
                endpoint: .login,
                body: body
            )
            TokenStorage.shared.accessToken = response.accessToken
            TokenStorage.shared.refreshToken = response.refreshToken
            UserSession.shared.setAuthenticatedUser(response.user, isDemo: false)
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }

    public func register(fullName: String, email: String, phone: String, password: String) async -> Bool {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        if NetworkConfiguration.shared.isDemoMode {
            try? await Task.sleep(nanoseconds: 600_000_000)
            let newUser = User(
                id: UUID().uuidString,
                email: email,
                fullName: fullName,
                phoneNumber: phone,
                role: .customer,
                customerSince: Date()
            )
            TokenStorage.shared.accessToken = "demo_access_token_jwt"
            TokenStorage.shared.refreshToken = "demo_refresh_token_jwt"
            UserSession.shared.setAuthenticatedUser(newUser, isDemo: true)
            return true
        }

        do {
            let body = [
                "fullName": fullName,
                "email": email,
                "phoneNumber": phone,
                "password": password
            ]
            let response: AuthResponse = try await APIClient.shared.request(
                endpoint: .register,
                body: body
            )
            TokenStorage.shared.accessToken = response.accessToken
            TokenStorage.shared.refreshToken = response.refreshToken
            UserSession.shared.setAuthenticatedUser(response.user, isDemo: false)
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }

    public func signOut() {
        UserSession.shared.signOut()
    }
}
