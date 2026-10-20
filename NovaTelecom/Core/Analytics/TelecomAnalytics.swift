import Foundation

public final class TelecomAnalytics: @unchecked Sendable {
    public static let shared = TelecomAnalytics()

    private var hasUserConsent: Bool = true

    private init() {}

    public func setConsent(granted: Bool) {
        self.hasUserConsent = granted
    }

    public func logEvent(name: String, parameters: [String: Any] = [:]) {
        guard hasUserConsent else { return }
        // Privacy conscious: no PII logged
        var sanitized = parameters
        sanitized.removeValue(forKey: "password")
        sanitized.removeValue(forKey: "token")
        sanitized.removeValue(forKey: "phoneNumber")
        TelecomLogger.ui.debug("📊 [Event: \(name)] Params: \(sanitized.description)")
    }

    public func logScreenView(screenName: String) {
        logEvent(name: "screen_view", parameters: ["screen_name": screenName])
    }
}
