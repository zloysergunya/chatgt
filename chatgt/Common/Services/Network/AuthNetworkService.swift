import Foundation
import Moya

/// Service for handling authentication token exchange and refresh.
///
/// ⚠️ MOCK IMPLEMENTATION — replace with real backend calls when the backend
/// endpoints `/api/auth/v1/token` and `/api/auth/v1/token/refresh` are ready.
///
/// ### What the backend needs to implement:
///
/// **POST /api/auth/v1/token** — Exchange OAuth token for backend tokens
/// - Request body:
///   ```json
///   {
///     "provider": "google" | "apple",
///     "token": "<OAuth ID token>",
///     "authorization_code": "<Apple authorization code, optional>"
///   }
///   ```
/// - Backend should:
///   1. Validate the OAuth token with Google/Apple
///   2. For Apple: exchange `authorization_code` with Apple's
///      `https://appleid.apple.com/auth/token` to obtain Apple's refresh token,
///      store it server-side
///   3. Create or find the user in the database
///   4. Issue backend JWT access token + refresh token
/// - Response (200):
///   ```json
///   {
///     "access_token": "<backend JWT>",
///     "refresh_token": "<backend refresh token>",
///     "expires_in": 3600
///   }
///   ```
///
/// **POST /api/auth/v1/token/refresh** — Refresh backend access token
/// - Request body:
///   ```json
///   {
///     "refresh_token": "<backend refresh token>"
///   }
///   ```
/// - Backend should:
///   1. Validate the refresh token
///   2. For Apple users: optionally re-validate with Apple's refresh token
///   3. Issue a new access token + refresh token pair
///   4. Invalidate the old refresh token (rotation)
/// - Response (200):
///   ```json
///   {
///     "access_token": "<new backend JWT>",
///     "refresh_token": "<new backend refresh token>",
///     "expires_in": 3600
///   }
///   ```
/// - Error (401): refresh token is invalid/expired → client must re-authenticate
final class AuthNetworkService {

    // MARK: - Singleton

    static let shared = AuthNetworkService()

    // MARK: - Private Properties

    private let provider: MoyaProvider<AuthAPI>

    // MARK: - Initialization

    init(provider: MoyaProvider<AuthAPI> = NetworkManager.shared.authProvider) {
        self.provider = provider
    }

    // MARK: - Token Exchange

    /// Exchange an OAuth token for backend access + refresh tokens.
    ///
    /// - Parameters:
    ///   - oauthToken: The ID token from Google or Apple Sign-In
    ///   - provider: The OAuth provider ("google" or "apple")
    ///   - authorizationCode: The authorization code from Apple (nil for Google)
    /// - Returns: `TokenResponse` containing backend tokens
    func exchangeToken(
        oauthToken: String,
        provider: AuthProvider,
        authorizationCode: String? = nil
    ) async throws -> TokenResponse {
        // TODO: Remove mock — use real network call below when backend is ready
        return try await exchangeTokenMock(
            oauthToken: oauthToken,
            provider: provider,
            authorizationCode: authorizationCode
        )

        // MARK: Real implementation (uncomment when backend is ready):
        // return try await withCheckedThrowingContinuation { continuation in
        //     self.provider.request(
        //         .exchangeToken(
        //             provider: provider.rawValue,
        //             oauthToken: oauthToken,
        //             authorizationCode: authorizationCode
        //         )
        //     ) { result in
        //         switch result {
        //         case .success(let response):
        //             if response.statusCode == 200 {
        //                 do {
        //                     let tokenResponse = try JSONDecoder().decode(
        //                         TokenResponse.self, from: response.data
        //                     )
        //                     continuation.resume(returning: tokenResponse)
        //                 } catch {
        //                     continuation.resume(throwing: APIError.decodingError(error))
        //                 }
        //             } else if response.statusCode == 401 {
        //                 continuation.resume(throwing: APIError.unauthorized)
        //             } else {
        //                 let message = String(data: response.data, encoding: .utf8)
        //                 continuation.resume(throwing: APIError.serverError(
        //                     statusCode: response.statusCode, message: message
        //                 ))
        //             }
        //         case .failure(let error):
        //             continuation.resume(throwing: APIError.networkError(error))
        //         }
        //     }
        // }
    }

    // MARK: - Token Refresh

    /// Refresh the backend access token using a refresh token.
    ///
    /// - Parameter refreshToken: The current refresh token
    /// - Returns: `TokenResponse` with new access + refresh tokens
    /// - Throws: `APIError.unauthorized` if refresh token is invalid (user must re-login)
    func refreshAccessToken(refreshToken: String) async throws -> TokenResponse {
        // TODO: Remove mock — use real network call below when backend is ready
        return try await refreshTokenMock(refreshToken: refreshToken)

        // MARK: Real implementation (uncomment when backend is ready):
        // return try await withCheckedThrowingContinuation { continuation in
        //     self.provider.request(.refreshToken(refreshToken: refreshToken)) { result in
        //         switch result {
        //         case .success(let response):
        //             if response.statusCode == 200 {
        //                 do {
        //                     let tokenResponse = try JSONDecoder().decode(
        //                         TokenResponse.self, from: response.data
        //                     )
        //                     continuation.resume(returning: tokenResponse)
        //                 } catch {
        //                     continuation.resume(throwing: APIError.decodingError(error))
        //                 }
        //             } else if response.statusCode == 401 {
        //                 continuation.resume(throwing: APIError.unauthorized)
        //             } else {
        //                 let message = String(data: response.data, encoding: .utf8)
        //                 continuation.resume(throwing: APIError.serverError(
        //                     statusCode: response.statusCode, message: message
        //                 ))
        //             }
        //         case .failure(let error):
        //             continuation.resume(throwing: APIError.networkError(error))
        //         }
        //     }
        // }
    }
}

// MARK: - Mock Implementations

private extension AuthNetworkService {

    func exchangeTokenMock(
        oauthToken: String,
        provider: AuthProvider,
        authorizationCode: String?
    ) async throws -> TokenResponse {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 300_000_000)

        // Return mock tokens (in production, backend generates these)
        return TokenResponse(
            accessToken: "mock_access_\(UUID().uuidString)",
            refreshToken: "mock_refresh_\(UUID().uuidString)",
            expiresIn: 3600
        )
    }

    func refreshTokenMock(refreshToken: String) async throws -> TokenResponse {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 300_000_000)

        // Simulate expired refresh token (for testing — remove in production)
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
