import Foundation
import AuthenticationServices

/// Service for handling Sign in with Apple authentication.
@MainActor
final class AppleAuthService: NSObject, AuthServiceProtocol {
    
    // MARK: - Singleton
    
    static let shared = AppleAuthService()
    
    // MARK: - Private Properties
    
    private var continuation: CheckedContinuation<AuthResult, Error>?
    
    private override init() {
        super.init()
    }
    
    // MARK: - AuthServiceProtocol
    
    func signIn() async throws -> AuthResult {
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            
            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
    }
    
    func signOut() async throws {
        // Apple Sign-In doesn't have a traditional sign-out
        // The app should clear its own session/token storage
        try await Task.sleep(nanoseconds: 500_000_000)
    }
}

// MARK: - ASAuthorizationControllerDelegate

extension AppleAuthService: ASAuthorizationControllerDelegate {
    
    nonisolated func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        Task { @MainActor in
            guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
                continuation?.resume(throwing: AuthError.failed("Invalid credential type"))
                continuation = nil
                return
            }
            
            // Extract identity token (JWT) for backend authentication
            guard let identityTokenData = appleIDCredential.identityToken,
                  let identityToken = String(data: identityTokenData, encoding: .utf8) else {
                continuation?.resume(throwing: AuthError.failed("Failed to get identity token"))
                continuation = nil
                return
            }
            
            let userId = appleIDCredential.user
            let email = appleIDCredential.email
            let fullName = [
                appleIDCredential.fullName?.givenName,
                appleIDCredential.fullName?.familyName
            ]
                .compactMap { $0 }
                .joined(separator: " ")

            // Extract authorization code for backend refresh token exchange
            let authorizationCode: String?
            if let codeData = appleIDCredential.authorizationCode {
                authorizationCode = String(data: codeData, encoding: .utf8)
            } else {
                authorizationCode = nil
            }

            let result = AuthResult(
                userId: userId,
                email: email,
                displayName: fullName.isEmpty ? nil : fullName,
                provider: .apple,
                token: identityToken,
                authorizationCode: authorizationCode
            )
            
            continuation?.resume(returning: result)
            continuation = nil
        }
    }
    
    nonisolated func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        Task { @MainActor in
            if let authError = error as? ASAuthorizationError {
                switch authError.code {
                case .canceled:
                    continuation?.resume(throwing: AuthError.cancelled)
                case .failed:
                    continuation?.resume(throwing: AuthError.failed("Authorization failed"))
                case .invalidResponse:
                    continuation?.resume(throwing: AuthError.failed("Invalid response"))
                case .notHandled:
                    continuation?.resume(throwing: AuthError.failed("Request not handled"))
                case .notInteractive:
                    continuation?.resume(throwing: AuthError.failed("Not interactive"))
                case .unknown:
                    continuation?.resume(throwing: AuthError.unknown)
                @unknown default:
                    continuation?.resume(throwing: AuthError.unknown)
                }
            } else {
                continuation?.resume(throwing: AuthError.failed(error.localizedDescription))
            }
            continuation = nil
        }
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension AppleAuthService: ASAuthorizationControllerPresentationContextProviding {
    
    nonisolated func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return ASPresentationAnchor()
        }
        return window
    }
}
