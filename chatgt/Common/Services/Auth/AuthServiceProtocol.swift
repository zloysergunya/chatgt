import Foundation

// MARK: - Auth Result

struct AuthResult {
    let userId: String
    let email: String?
    let displayName: String?
    let provider: AuthProvider
    let token: String?  // JWT token from Apple/Google
    let authorizationCode: String?  // Authorization code (Apple only, needed for backend refresh token exchange)

    init(
        userId: String,
        email: String? = nil,
        displayName: String? = nil,
        provider: AuthProvider,
        token: String? = nil,
        authorizationCode: String? = nil
    ) {
        self.userId = userId
        self.email = email
        self.displayName = displayName
        self.provider = provider
        self.token = token
        self.authorizationCode = authorizationCode
    }
}

// MARK: - Auth Provider

enum AuthProvider: String {
    case google
    case apple
    case email
}

// MARK: - Auth Error

enum AuthError: LocalizedError {
    case cancelled
    case failed(String)
    case invalidCredentials
    case networkError
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .cancelled:
            return "Sign in was cancelled"
        case .failed(let message):
            return message
        case .invalidCredentials:
            return "Invalid credentials"
        case .networkError:
            return "Network error. Please check your connection"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}

// MARK: - Auth Service Protocol

protocol AuthServiceProtocol {
    func signIn() async throws -> AuthResult
    func signOut() async throws
}
