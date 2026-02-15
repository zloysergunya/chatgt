import Foundation
import Moya

/// Service for handling authentication token exchange and refresh.
///
/// ## ⚠️ Currently uses MOCK implementation.
/// When the backend is ready, set `useMock = false` and the real Moya
/// requests will be used automatically. No other changes needed.
///
/// ### Backend endpoints required:
///
/// **POST /api/auth/v1/token** — Exchange OAuth token for backend tokens
/// - Request: `{ "provider": "google"|"apple", "token": "<ID token>", "authorization_code": "<optional>" }`
/// - Response 200: `{ "access_token": "...", "refresh_token": "...", "expires_in": 3600 }`
/// - Response 401: Invalid OAuth token
///
/// **POST /api/auth/v1/token/refresh** — Refresh backend access token
/// - Request: `{ "refresh_token": "..." }`
/// - Response 200: `{ "access_token": "...", "refresh_token": "...", "expires_in": 3600 }`
/// - Response 401: Refresh token expired/invalid → client must re-authenticate
final class AuthNetworkService {

    // MARK: - Singleton

    static let shared = AuthNetworkService()

    // MARK: - Configuration

    /// Set to `false` when the real backend endpoints are ready.
    private let useMock = true

    // MARK: - Private Properties

    private let provider: MoyaProvider<AuthAPI>

    // MARK: - Initialization

    init(provider: MoyaProvider<AuthAPI> = NetworkManager.shared.authProvider) {
        self.provider = provider
    }

    // MARK: - Token Exchange

    /// Exchange an OAuth token for backend access + refresh tokens.
    func exchangeToken(
        oauthToken: String,
        provider: AuthProvider,
        authorizationCode: String? = nil
    ) async throws -> TokenResponse {
        guard !useMock else {
            return try await exchangeTokenMock(
                oauthToken: oauthToken,
                provider: provider,
                authorizationCode: authorizationCode
            )
        }

        return try await withCheckedThrowingContinuation { continuation in
            self.provider.request(
                .exchangeToken(
                    provider: provider.rawValue,
                    oauthToken: oauthToken,
                    authorizationCode: authorizationCode
                )
            ) { result in
                Self.handleTokenResponse(result, continuation: continuation)
            }
        }
    }

    // MARK: - Token Refresh

    /// Refresh the backend access token using a refresh token.
    ///
    /// - Throws: `APIError.unauthorized` if refresh token is invalid (triggers session expiry)
    func refreshAccessToken(refreshToken: String) async throws -> TokenResponse {
        guard !useMock else {
            return try await refreshTokenMock(refreshToken: refreshToken)
        }

        return try await withCheckedThrowingContinuation { continuation in
            self.provider.request(.refreshToken(refreshToken: refreshToken)) { result in
                Self.handleTokenResponse(result, continuation: continuation)
            }
        }
    }

    // MARK: - Response Handling

    private static func handleTokenResponse(
        _ result: Result<Response, MoyaError>,
        continuation: CheckedContinuation<TokenResponse, Error>
    ) {
        switch result {
        case .success(let response):
            if response.statusCode == 200 {
                do {
                    let tokenResponse = try JSONDecoder().decode(
                        TokenResponse.self, from: response.data
                    )
                    continuation.resume(returning: tokenResponse)
                } catch {
                    continuation.resume(throwing: APIError.decodingError(error))
                }
            } else if response.statusCode == 401 {
                continuation.resume(throwing: APIError.unauthorized)
            } else {
                let message = String(data: response.data, encoding: .utf8)
                continuation.resume(throwing: APIError.serverError(
                    statusCode: response.statusCode, message: message
                ))
            }
        case .failure(let error):
            switch error {
            case .underlying(let underlyingError, _):
                continuation.resume(throwing: APIError.networkError(underlyingError))
            default:
                continuation.resume(throwing: APIError.networkError(error))
            }
        }
    }
}

// MARK: - Mock Implementations

private extension AuthNetworkService {

    func exchangeTokenMock(
        oauthToken: String,
        provider: AuthProvider,
        authorizationCode: String?
    ) async throws -> TokenResponse {
        try await Task.sleep(nanoseconds: 300_000_000) // simulate 0.3s latency

        return TokenResponse(
            accessToken: "mock_access_\(UUID().uuidString)",
            refreshToken: "mock_refresh_\(UUID().uuidString)",
            expiresIn: 3600
        )
    }

    func refreshTokenMock(refreshToken: String) async throws -> TokenResponse {
        try await Task.sleep(nanoseconds: 300_000_000) // simulate 0.3s latency

        // Simulate expired refresh token
        guard !refreshToken.isEmpty else {
            throw APIError.unauthorized
        }

        return TokenResponse(
            accessToken: "mock_access_\(UUID().uuidString)",
            refreshToken: "mock_refresh_\(UUID().uuidString)",
            expiresIn: 3600
        )
    }
}
