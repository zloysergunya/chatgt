import Foundation
import KeychainAccess

/// Service for secure token storage using Keychain
final class TokenStorage {
    
    // MARK: - Singleton
    
    static let shared = TokenStorage()
    
    // MARK: - Constants
    
    private enum Keys {
        static let accessToken = "com.chatgt.accessToken"
        static let refreshToken = "com.chatgt.refreshToken"
        static let userIdentifier = "com.chatgt.userIdentifier"
        static let authProvider = "com.chatgt.authProvider"
        static let tokenExpirationDate = "com.chatgt.tokenExpirationDate"
    }
    
    // MARK: - Private Properties
    
    private let keychain: Keychain
    
    // MARK: - Initialization
    
    private init() {
        keychain = Keychain(service: "com.chatgt.auth")
            .accessibility(.afterFirstUnlockThisDeviceOnly)
    }
    
    // MARK: - Access Token
    
    /// Save access token to Keychain
    func saveAccessToken(_ token: String) throws {
        try keychain.set(token, key: Keys.accessToken)
    }
    
    /// Get access token from Keychain
    func getAccessToken() -> String? {
        try? keychain.get(Keys.accessToken)
    }
    
    /// Remove access token from Keychain
    func removeAccessToken() throws {
        try keychain.remove(Keys.accessToken)
    }
    
    // MARK: - Refresh Token
    
    /// Save refresh token to Keychain
    func saveRefreshToken(_ token: String) throws {
        try keychain.set(token, key: Keys.refreshToken)
    }
    
    /// Get refresh token from Keychain
    func getRefreshToken() -> String? {
        try? keychain.get(Keys.refreshToken)
    }
    
    /// Remove refresh token from Keychain
    func removeRefreshToken() throws {
        try keychain.remove(Keys.refreshToken)
    }
    
    // MARK: - User Identifier
    
    /// Save user identifier to Keychain
    func saveUserIdentifier(_ identifier: String) throws {
        try keychain.set(identifier, key: Keys.userIdentifier)
    }
    
    /// Get user identifier from Keychain
    func getUserIdentifier() -> String? {
        try? keychain.get(Keys.userIdentifier)
    }
    
    /// Remove user identifier from Keychain
    func removeUserIdentifier() throws {
        try keychain.remove(Keys.userIdentifier)
    }
    
    // MARK: - Auth Provider

    /// Save the auth provider used for sign-in
    func saveAuthProvider(_ provider: AuthProvider) throws {
        try keychain.set(provider.rawValue, key: Keys.authProvider)
    }

    /// Get the auth provider used for sign-in
    func getAuthProvider() -> AuthProvider? {
        guard let raw = try? keychain.get(Keys.authProvider) else { return nil }
        return AuthProvider(rawValue: raw)
    }

    /// Remove auth provider
    func removeAuthProvider() throws {
        try keychain.remove(Keys.authProvider)
    }

    // MARK: - Token Expiration

    /// Save the token expiration date
    func saveTokenExpirationDate(_ date: Date) throws {
        let timestamp = String(date.timeIntervalSince1970)
        try keychain.set(timestamp, key: Keys.tokenExpirationDate)
    }

    /// Get the token expiration date
    func getTokenExpirationDate() -> Date? {
        guard let timestamp = try? keychain.get(Keys.tokenExpirationDate),
              let interval = TimeInterval(timestamp) else { return nil }
        return Date(timeIntervalSince1970: interval)
    }

    /// Check if the access token has expired (with a 60-second margin)
    var isAccessTokenExpired: Bool {
        guard let expirationDate = getTokenExpirationDate() else {
            // No expiration stored — consider expired to be safe
            return true
        }
        return Date().addingTimeInterval(60) >= expirationDate
    }

    // MARK: - Clear All

    /// Clear all stored tokens and data
    func clearAll() throws {
        try keychain.removeAll()
    }

    // MARK: - Auth State

    /// Check if user is authenticated (has valid access token)
    var isAuthenticated: Bool {
        getAccessToken() != nil
    }
}
