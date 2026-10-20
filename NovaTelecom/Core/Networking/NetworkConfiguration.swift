import Foundation

public final class NetworkConfiguration: @unchecked Sendable {
    public enum Environment: String, CaseIterable, Sendable {
        case local = "Localhost Backend"
        case staging = "Staging Cloud"
        case production = "Production"
        case demoMode = "Demo Simulation"

        public var baseURL: URL {
            switch self {
            case .local:
                return URL(string: "http://127.0.0.1:4000/api/v1")!
            case .staging:
                return URL(string: "https://staging-api.novatelecom.net/api/v1")!
            case .production:
                return URL(string: "https://api.novatelecom.net/api/v1")!
            case .demoMode:
                return URL(string: "https://demo.novatelecom.internal/api/v1")!
            }
        }
    }

    public static let shared = NetworkConfiguration()

    public var currentEnvironment: Environment = .local
    public var isDemoMode: Bool = true // Enabled by default for complete offline / simulator reliability
    public var requestTimeout: TimeInterval = 15.0

    private init() {}
}
