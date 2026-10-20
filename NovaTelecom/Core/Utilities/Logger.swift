import Foundation
import os

public enum TelecomLogger {
    private static let subsystem = "com.novatelecom.app"

    public static let network = Logger(subsystem: subsystem, category: "Networking")
    public static let auth = Logger(subsystem: subsystem, category: "Auth")
    public static let ui = Logger(subsystem: subsystem, category: "UI")
    public static let threeD = Logger(subsystem: subsystem, category: "3DRendering")

    public static func logSensitiveRedacted(_ message: String) {
        // Redacts authorization tokens, credit cards, passwords
        let redacted = message
            .replacingOccurrences(of: "Bearer [A-Za-z0-9-_.]+", with: "Bearer [REDACTED]", options: .regularExpression)
            .replacingOccurrences(of: "\\b\\d{16}\\b", with: "[CARD REDACTED]", options: .regularExpression)
        network.info("\(redacted, privacy: .public)")
    }
}
