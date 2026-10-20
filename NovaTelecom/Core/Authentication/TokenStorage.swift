import Foundation

public final class TokenStorage: @unchecked Sendable {
    public static let shared = TokenStorage()

    private let accessTokenKey = "nova_telecom_access_token"
    private let refreshTokenKey = "nova_telecom_refresh_token"

    private init() {}

    public var accessToken: String? {
        get {
            KeychainService.loadString(key: accessTokenKey)
        }
        set {
            if let newValue = newValue {
                _ = KeychainService.saveString(key: accessTokenKey, string: newValue)
            } else {
                _ = KeychainService.delete(key: accessTokenKey)
            }
        }
    }

    public var refreshToken: String? {
        get {
            KeychainService.loadString(key: refreshTokenKey)
        }
        set {
            if let newValue = newValue {
                _ = KeychainService.saveString(key: refreshTokenKey, string: newValue)
            } else {
                _ = KeychainService.delete(key: refreshTokenKey)
            }
        }
    }

    public func clearTokens() {
        _ = KeychainService.delete(key: accessTokenKey)
        _ = KeychainService.delete(key: refreshTokenKey)
    }

    public var hasValidToken: Bool {
        return accessToken != nil && !(accessToken?.isEmpty ?? true)
    }
}
