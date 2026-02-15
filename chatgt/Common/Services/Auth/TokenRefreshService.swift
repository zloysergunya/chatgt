import Foundation

/// Orchestrates token refresh logic for both Google and Apple auth providers.
///
/// Uses `actor` to guarantee thread-safe access and prevent concurrent refresh requests
/// (multiple 401 responses shouldn't trigger multiple refresh calls simultaneously).
actor TokenRefreshService {

    // MARK: - Singleton

    static let shared = TokenRefreshService()

    // MARK: - Dependencies

    private let tokenStorage: TokenStorage
    private let authNetworkService: AuthNetworkService
    private let googleAuthService: GoogleAuthService

    // MARK: - State

    /// In-flight refresh task to coalesce concurrent refresh requests
    private var refreshTask: Task<String, Error>?

    // MARK: - Initialization

    init(
        tokenStorage: TokenStorage = .shared,
        authNetworkService: AuthNetworkService = .shared,
        googleAuthService: GoogleAuthService = .shared
    ) {
        self.tokenStorage = tokenStorage
        self.authNetworkService = authNetworkService
        self.googleAuthService = googleAuthService
    }

    // MARK: - Public API

    /// Returns a valid access token, refreshing if necessary.
    ///
    /// Call this before making API requests to ensure the token is still valid.
    /// If the token is expired, it will be refreshed automatically.
    ///
    /// - Returns: A valid access token string
    /// - Throws: `APIError.unauthorized` if the token cannot be refreshed (user must re-login)
    func getValidAccessToken() async throws -> String {
        // If there's an in-flight refresh, wait for it
        if let existingTask = refreshTask {
            return try await existingTask.value
        }

        // Check if current token is still valid
        if let token = tokenStorage.getAccessToken(), !tokenStorage.isAccessTokenExpired {
            return token
        }

        // Token is expired or missing — refresh it
        return try await refreshAccessToken()
    }

    /// Force-refresh the access token. Call this on 401 responses.
    ///
    /// - Returns: A new access token string
    /// - Throws: `APIError.unauthorized` if the token cannot be refreshed
    @discardableResult
    func forceRefresh() async throws -> String {
        // If there's an in-flight refresh, wait for it instead of starting another
        if let existingTask = refreshTask {
            return try await existingTask.value
        }

        return try await refreshAccessToken()
    }

    /// Save tokens from initial authentication (called after sign-in).
    func saveTokens(from response: TokenResponse, provider: AuthProvider) {
        try? tokenStorage.saveAccessToken(response.accessToken)
        try? tokenStorage.saveRefreshToken(response.refreshToken)
        try? tokenStorage.saveAuthProvider(provider)

        let expirationDate = Date().addingTimeInterval(TimeInterval(response.expiresIn))
        try? tokenStorage.saveTokenExpirationDate(expirationDate)
    }

    // MARK: - Private

    private func refreshAccessToken() async throws -> String {
        let task = Task<String, Error> { [weak self] in
            guard let self else { throw APIError.unauthorized }

            let provider = self.tokenStorage.getAuthProvider()

            // Strategy 1 (Google only): Try silent SDK refresh to get a new OAuth token,
            // then exchange it for backend tokens
            if provider == .google {
                let newIdToken = await MainActor.run {
                    await self.googleAuthService.refreshTokenSilently()
                }

                if let idToken = newIdToken {
                    let response = try await self.authNetworkService.exchangeToken(
                        oauthToken: idToken,
                        provider: .google
                    )
                    self.saveTokens(from: response, provider: .google)
                    return response.accessToken
                }
            }

            // Strategy 2 (both providers): Use the backend refresh token
            guard let refreshToken = self.tokenStorage.getRefreshToken() else {
                throw APIError.unauthorized
            }

            do {
                let response = try await self.authNetworkService.refreshAccessToken(
                    refreshToken: refreshToken
                )
                self.saveTokens(from: response, provider: provider ?? .google)
                return response.accessToken
            } catch {
                // Refresh failed — clear tokens, user must re-authenticate
                try? self.tokenStorage.clearAll()
                throw APIError.unauthorized
            }
        }

        refreshTask = task

        do {
            let token = try await task.value
            refreshTask = nil
            return token
        } catch {
            refreshTask = nil
            throw error
        }
    }
}
