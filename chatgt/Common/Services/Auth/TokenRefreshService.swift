import Foundation
import GoogleSignIn

/// Centralized service for refreshing expired auth tokens.
/// Google: refreshes via SDK. Apple: refreshes via backend.
@MainActor
final class TokenRefreshService {

    static let shared = TokenRefreshService()

    private let tokenStorage: TokenStorage
    private let profileService: ProfileService

    /// Prevents multiple concurrent refresh attempts — all callers share the same in-flight task
    private var refreshTask: Task<String, Error>?

    private init(
        tokenStorage: TokenStorage = .shared,
        profileService: ProfileService = .shared
    ) {
        self.tokenStorage = tokenStorage
        self.profileService = profileService
    }

    /// Attempt to refresh the current access token.
    /// - Returns: Fresh JWT token
    /// - Throws: `AuthError` if refresh fails (user must sign in again)
    func refreshToken() async throws -> String {
        // If a refresh is already in progress, wait for it
        if let existingTask = refreshTask {
            return try await existingTask.value
        }

        let task = Task<String, Error> {
            defer { refreshTask = nil }

            guard let provider = tokenStorage.getAuthProvider() else {
                throw AuthError.failed("No auth provider stored. Please sign in again.")
            }

            let newToken: String

            switch provider {
            case .google:
                newToken = try await refreshGoogleToken()
            case .apple:
                newToken = try await refreshAppleToken()
            case .email:
                throw AuthError.failed("Email token refresh not supported. Please sign in again.")
            }

            try tokenStorage.saveAccessToken(newToken)

            return newToken
        }

        refreshTask = task
        return try await task.value
    }

    // MARK: - Google Refresh (SDK)

    private func refreshGoogleToken() async throws -> String {
        // Restore session from Google's internal keychain
        guard let user = try? await GIDSignIn.sharedInstance.restorePreviousSignIn() else {
            throw AuthError.failed("Google session expired. Please sign in again.")
        }

        // Refreshes tokens only if actually expired
        let refreshedUser = try await user.refreshTokensIfNeeded()

        guard let idToken = refreshedUser.idToken?.tokenString else {
            throw AuthError.failed("Failed to get refreshed Google ID token.")
        }

        let tokenPair = try await profileService.createProfile(token: idToken)
        try tokenStorage.saveRefreshToken(tokenPair.refreshToken)
        return tokenPair.idToken
    }

    // MARK: - Apple Refresh (Backend)

    private func refreshAppleToken() async throws -> String {
        guard let accessToken = tokenStorage.getAccessToken() else {
            throw AuthError.failed("No access token stored. Please sign in again.")
        }
        guard let refreshToken = tokenStorage.getRefreshToken() else {
            throw AuthError.failed("No refresh token stored. Please sign in again.")
        }

        let tokenPair = try await profileService.refreshAppleToken(token: accessToken, refreshToken: refreshToken)
        try tokenStorage.saveRefreshToken(tokenPair.refreshToken)
        return tokenPair.idToken
    }
}
