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
