import Foundation

public enum HTTPMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case put = "PUT"
    case delete = "DELETE"
}

public enum NetworkError: LocalizedError, Equatable, Sendable {
    case invalidURL
    case serializationError
    case decodingError(String)
    case unauthorized
    case forbidden
    case notFound
    case serverError(statusCode: Int, message: String)
    case connectionFailed(String)
    case demoModeFallback

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The requested URL was invalid."
        case .serializationError:
            return "Failed to serialize the request payload."
        case .decodingError(let msg):
            return "Failed to parse server response: \(msg)"
        case .unauthorized:
            return "Your session has expired. Please sign in again."
        case .forbidden:
            return "You do not have permission to access this resource."
        case .notFound:
            return "The requested telecom service or product was not found."
        case .serverError(let code, let msg):
            return "Server error (\(code)): \(msg)"
        case .connectionFailed(let details):
            return "Network connection unavailable: \(details)"
        case .demoModeFallback:
            return "Running in demo simulation mode."
        }
    }
}
