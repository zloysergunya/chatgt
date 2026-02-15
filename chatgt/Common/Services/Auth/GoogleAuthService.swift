import Foundation
import GoogleSignIn

/// Service for handling Google Sign-In authentication.
@MainActor
final class GoogleAuthService: AuthServiceProtocol {
    
    // MARK: - Singleton
    
    static let shared = GoogleAuthService()
    
    private init() {}
    
    // MARK: - AuthServiceProtocol
    
    func signIn() async throws -> AuthResult {
        // Get the root view controller for presenting the sign-in flow
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            throw AuthError.failed("Unable to get root view controller")
        }
        
        do {            
            // Perform Google Sign-In
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            let user = result.user
            
            // Extract ID token for backend authentication
            guard let idToken = user.idToken?.tokenString else {
                throw AuthError.failed("Failed to get ID token from Google")
            }
            
            return AuthResult(
                userId: user.userID ?? UUID().uuidString,
                email: user.profile?.email,
                displayName: user.profile?.name,
                provider: .google,
                token: idToken
            )
        } catch let error as GIDSignInError {
            switch error.code {
            case .canceled:
                throw AuthError.cancelled
            case .hasNoAuthInKeychain:
                throw AuthError.failed("No previous sign-in found")
            case .EMM:
                throw AuthError.failed("Enterprise Mobility Management error")
            case .scopesAlreadyGranted:
                throw AuthError.failed("Scopes already granted")
            case .mismatchWithCurrentUser:
                throw AuthError.failed("User mismatch")
            case .unknown:
                throw AuthError.unknown
            @unknown default:
                throw AuthError.unknown
            }
        } catch {
            throw AuthError.failed(error.localizedDescription)
        }
    }
    
    func signOut() async throws {
        GIDSignIn.sharedInstance.signOut()
    }
    
    // MARK: - Restore Previous Sign-In

    /// Attempt to restore a previous sign-in session
    func restorePreviousSignIn() async throws -> AuthResult? {
        do {
            let user = try await GIDSignIn.sharedInstance.restorePreviousSignIn()

            guard let idToken = user.idToken?.tokenString else {
                return nil
            }

            return AuthResult(
                userId: user.userID ?? UUID().uuidString,
                email: user.profile?.email,
                displayName: user.profile?.name,
                provider: .google,
                token: idToken
            )
        } catch {
            // No previous sign-in or restoration failed
            return nil
        }
    }

    // MARK: - Silent Token Refresh

    /// Silently refresh the Google ID token using the SDK's internal refresh token.
    /// Google Sign-In SDK stores its own refresh token and can issue a new ID token
    /// without user interaction.
    /// - Returns: Fresh ID token string, or nil if refresh failed
    func refreshTokenSilently() async -> String? {
        do {
            let user = try await GIDSignIn.sharedInstance.restorePreviousSignIn()
            // refreshTokensIfNeeded forces a token refresh if the current one is expired
            let refreshResult = try await user.refreshTokensIfNeeded()
            return refreshResult.idToken?.tokenString
        } catch {
            return nil
        }
    }
}
