import Foundation

/// Orchestrates backend token refresh for all auth providers.
///
/// Uses `actor` to guarantee thread-safe access and prevent concurrent refresh requests
/// (multiple 401 responses won't trigger multiple refresh calls simultaneously).
///
/// ## Covered scenarios:
/// 1. **Proactive refresh** — `scheduleProactiveRefresh()` refreshes the token before it expires
/// 2. **On-demand refresh** — `getValidAccessToken()` checks expiration before every API call
/// 3. **Force refresh on 401** — `forceRefresh()` called by services when the backend returns 401
/// 4. **Concurrent 401s** — coalesced via `refreshTask` (only one refresh in flight at a time)
/// 5. **Network errors during refresh** — retries up to 3 times with exponential backoff
/// 6. **Refresh token expired** — posts `Notification.Name.sessionExpired` for UI to redirect to login
/// 7. **App foreground** — call `refreshIfNeeded()` from `scenePhase` handler
actor TokenRefreshService {

    // MARK: - Singleton

    static let shared = TokenRefreshService()

    // MARK: - Dependencies

    private let tokenStorage: TokenStorage
    private let authNetworkService: AuthNetworkService

    // MARK: - State

    /// In-flight refresh task — coalesces concurrent refresh requests
    private var refreshTask: Task<String, Error>?

    /// Proactive refresh task that fires before token expiration
    private var proactiveRefreshTask: Task<Void, Never>?

    // MARK: - Constants

    private let maxRetryCount = 3
    /// Refresh the token this many seconds before actual expiration
    private let proactiveRefreshMargin: TimeInterval = 300 // 5 minutes

    // MARK: - Initialization

    init(
        tokenStorage: TokenStorage = .shared,
        authNetworkService: AuthNetworkService = .shared
    ) {
        self.tokenStorage = tokenStorage
        self.authNetworkService = authNetworkService
    }

    // MARK: - Public API

    /// Returns a valid access token, refreshing if necessary.
    ///
    /// Call this before making API requests to ensure the token is still valid.
    /// - Returns: A valid access token string
    /// - Throws: `APIError.sessionExpired` if the token cannot be refreshed
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
        return try await performRefresh()
    }

    /// Force-refresh the access token. Call this when a service receives 401.
    ///
    /// - Returns: A new access token string
    /// - Throws: `APIError.sessionExpired` if the token cannot be refreshed
    @discardableResult
    func forceRefresh() async throws -> String {
        // If there's an in-flight refresh, wait for it instead of starting another
        if let existingTask = refreshTask {
            return try await existingTask.value
        }

        return try await performRefresh()
    }

    /// Check and refresh if needed — call on app foreground.
    ///
    /// Non-throwing: silently handles errors. If the refresh fails,
    /// the next API call will catch it and redirect to login.
    func refreshIfNeeded() async {
        guard tokenStorage.getAccessToken() != nil else { return }
        guard tokenStorage.isAccessTokenExpired else { return }

        do {
            try await performRefresh()
        } catch {
            // Will be handled when the next API call fails
        }
    }

    /// Save tokens from initial authentication (called after sign-in) and schedule proactive refresh.
    func saveTokens(from response: TokenResponse, provider: AuthProvider) {
        try? tokenStorage.saveAccessToken(response.accessToken)
        try? tokenStorage.saveRefreshToken(response.refreshToken)
        try? tokenStorage.saveAuthProvider(provider)

        let expirationDate = Date().addingTimeInterval(TimeInterval(response.expiresIn))
        try? tokenStorage.saveTokenExpirationDate(expirationDate)

        scheduleProactiveRefresh(expiresIn: TimeInterval(response.expiresIn))
    }

    /// Schedule a proactive refresh that fires before the token expires.
    ///
    /// Call this on app launch if the user is authenticated, or after every successful refresh.
    func scheduleProactiveRefresh(expiresIn: TimeInterval? = nil) {
        proactiveRefreshTask?.cancel()

        let delay: TimeInterval
        if let expiresIn {
            delay = max(expiresIn - proactiveRefreshMargin, 0)
        } else if let expirationDate = tokenStorage.getTokenExpirationDate() {
            let remaining = expirationDate.timeIntervalSinceNow
            delay = max(remaining - proactiveRefreshMargin, 0)
        } else {
            return
        }

        proactiveRefreshTask = Task { [weak self] in
            do {
                try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            } catch {
                return // Task was cancelled
            }

            guard !Task.isCancelled else { return }
            await self?.refreshIfNeeded()
        }
    }

    /// Cancel proactive refresh (call on sign-out).
    func cancelProactiveRefresh() {
        proactiveRefreshTask?.cancel()
        proactiveRefreshTask = nil
    }

    // MARK: - Private

    @discardableResult
    private func performRefresh() async throws -> String {
        let task = Task<String, Error> {
            guard let refreshToken = self.tokenStorage.getRefreshToken() else {
                self.handleSessionExpired()
                throw APIError.sessionExpired
            }

            // Retry with exponential backoff on network errors
            var lastError: Error = APIError.unknown
            for attempt in 0..<self.maxRetryCount {
                do {
                    let response = try await self.authNetworkService.refreshAccessToken(
                        refreshToken: refreshToken
                    )

                    // Success — save new tokens and schedule next proactive refresh
                    self.saveTokens(
                        from: response,
                        provider: self.tokenStorage.getAuthProvider() ?? .google
                    )
                    return response.accessToken

                } catch let error as APIError {
                    switch error {
                    case .unauthorized, .sessionExpired:
                        // Refresh token is invalid — session is over
                        self.handleSessionExpired()
                        throw APIError.sessionExpired

                    case .networkError:
                        // Network error — retry with exponential backoff
                        lastError = error
                        if attempt < self.maxRetryCount - 1 {
                            let delay = UInt64(pow(2.0, Double(attempt))) * 1_000_000_000
                            try await Task.sleep(nanoseconds: delay)
                        }

                    default:
                        // Server error or other — don't retry
                        throw error
                    }
                } catch {
                    lastError = error
                    if attempt < self.maxRetryCount - 1 {
                        let delay = UInt64(pow(2.0, Double(attempt))) * 1_000_000_000
                        try await Task.sleep(nanoseconds: delay)
                    }
                }
            }

            // All retries exhausted
            throw lastError
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

    private func handleSessionExpired() {
        try? tokenStorage.clearAll()
        cancelProactiveRefresh()
        NotificationCenter.default.post(name: .sessionExpired, object: nil)
    }
}
