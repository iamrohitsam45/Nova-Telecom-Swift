import Foundation

public final class APIClient: @unchecked Sendable {
    public static let shared = APIClient()

    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15.0
        config.timeoutIntervalForResource = 30.0
        self.session = URLSession(configuration: config)

        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601

        self.encoder = JSONEncoder()
        self.encoder.dateEncodingStrategy = .iso8601
    }

    public func request<T: Decodable>(
        endpoint: APIEndpoint,
        body: (any Encodable)? = nil,
        headers: [String: String] = [:]
    ) async throws -> T {
        // If in demo simulation mode, route directly to DemoDataStore
        if NetworkConfiguration.shared.isDemoMode {
            return try await DemoDataStore.shared.handleDemoRequest(endpoint: endpoint, body: body)
        }

        let baseURL = NetworkConfiguration.shared.currentEnvironment.baseURL
        guard let url = URL(string: baseURL.absoluteString + endpoint.path) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        // Add Bearer Token if present
        if let token = TokenStorage.shared.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        // Add custom headers
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        // Encode body if present
        if let body = body {
            do {
                request.httpBody = try encoder.encode(body)
            } catch {
                throw NetworkError.serializationError
            }
        }

        return try await executeWithRetry(request: request, endpoint: endpoint, retries: 2)
    }

    private func executeWithRetry<T: Decodable>(
        request: URLRequest,
        endpoint: APIEndpoint,
        retries: Int
    ) async throws -> T {
        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.connectionFailed("Invalid response type from server.")
            }

            switch httpResponse.statusCode {
            case 200...299:
                do {
                    return try decoder.decode(T.self, from: data)
                } catch {
                    throw NetworkError.decodingError(error.localizedDescription)
                }

            case 401:
                // Handle token refresh
                if TokenStorage.shared.refreshToken != nil {
                    let refreshed = await refreshAccessToken()
                    if refreshed {
                        var updatedRequest = request
                        if let newToken = TokenStorage.shared.accessToken {
                            updatedRequest.setValue("Bearer \(newToken)", forHTTPHeaderField: "Authorization")
                        }
                        let (retryData, retryResponse) = try await session.data(for: updatedRequest)
                        if let retryHttp = retryResponse as? HTTPURLResponse, (200...299).contains(retryHttp.statusCode) {
                            return try decoder.decode(T.self, from: retryData)
                        }
                    }
                }
                throw NetworkError.unauthorized

            case 403:
                throw NetworkError.forbidden

            case 404:
                throw NetworkError.notFound

            case 500...599 where retries > 0:
                try await Task.sleep(nanoseconds: 500_000_000)
                return try await executeWithRetry(request: request, endpoint: endpoint, retries: retries - 1)

            default:
                let msg = String(data: data, encoding: .utf8) ?? "HTTP status \(httpResponse.statusCode)"
                throw NetworkError.serverError(statusCode: httpResponse.statusCode, message: msg)
            }
        } catch let netErr as NetworkError {
            throw netErr
        } catch {
            // If local backend is unreachable, gracefully fall back to DemoDataStore to guarantee flawless UX!
            if NetworkConfiguration.shared.currentEnvironment == .local {
                return try await DemoDataStore.shared.handleDemoRequest(endpoint: endpoint, body: nil)
            }
            throw NetworkError.connectionFailed(error.localizedDescription)
        }
    }

    private func refreshAccessToken() async -> Bool {
        guard let refreshToken = TokenStorage.shared.refreshToken else { return false }
        let baseURL = NetworkConfiguration.shared.currentEnvironment.baseURL
        guard let url = URL(string: baseURL.absoluteString + "/auth/refresh") else { return false }

        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try? JSONSerialization.data(withJSONObject: ["refreshToken": refreshToken])

        do {
            let (data, response) = try await session.data(for: req)
            guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                TokenStorage.shared.clearTokens()
                return false
            }

            struct RefreshResponse: Decodable {
                let accessToken: String
                let refreshToken: String?
            }

            let result = try decoder.decode(RefreshResponse.self, from: data)
            TokenStorage.shared.accessToken = result.accessToken
            if let newRefresh = result.refreshToken {
                TokenStorage.shared.refreshToken = newRefresh
            }
            return true
        } catch {
            return false
        }
    }
}
