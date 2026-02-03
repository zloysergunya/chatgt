import Foundation
import Combine

@MainActor
final class SignInViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    @Published var authSuccess: Bool = false
    @Published var currentAuthResult: AuthResult?
    
    // MARK: - Dependencies
    
    private let googleAuthService: GoogleAuthService
    private let appleAuthService: AppleAuthService
    private let emailAuthService: EmailAuthService
    private let profileService: ProfileService
    private let tokenStorage: TokenStorage
    
    // MARK: - Initialization
    
    init(
        googleAuthService: GoogleAuthService = .shared,
        appleAuthService: AppleAuthService = .shared,
        emailAuthService: EmailAuthService = .shared,
        profileService: ProfileService = .shared,
        tokenStorage: TokenStorage = .shared
    ) {
        self.googleAuthService = googleAuthService
        self.appleAuthService = appleAuthService
        self.emailAuthService = emailAuthService
        self.profileService = profileService
        self.tokenStorage = tokenStorage
    }
    
    // MARK: - Public Methods
    
    func signInWithGoogle() async {
        await performSignIn(requiresBackendAuth: true) {
            try await self.googleAuthService.signIn()
        }
    }
    
    func signInWithApple() async {
        await performSignIn(requiresBackendAuth: true) {
            try await self.appleAuthService.signIn()
        }
    }
    
    func signInWithEmail(email: String, password: String) async {
        await performSignIn(requiresBackendAuth: false) {
            try await self.emailAuthService.signIn(email: email, password: password)
        }
    }
    
    func signUpWithEmail(email: String, password: String, displayName: String? = nil) async {
        await performSignIn(requiresBackendAuth: false) {
            try await self.emailAuthService.signUp(email: email, password: password, displayName: displayName)
        }
    }
    
    func resetPassword(email: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await emailAuthService.resetPassword(email: email)
            // Show success message or navigate to confirmation screen
        } catch let error as AuthError {
            showError(message: error.localizedDescription)
        } catch {
            showError(message: error.localizedDescription)
        }
        
        isLoading = false
    }
    
    func signOut() async {
        isLoading = true
        
        do {
            // Sign out from all providers
            try await googleAuthService.signOut()
            try await appleAuthService.signOut()
            try await emailAuthService.signOut()
            
            // Clear stored tokens
            try tokenStorage.clearAll()
            
            currentAuthResult = nil
            authSuccess = false
        } catch {
            showError(message: error.localizedDescription)
        }
        
        isLoading = false
    }
    
    // MARK: - Private Methods
    
    private func performSignIn(
        requiresBackendAuth: Bool,
        action: @escaping () async throws -> AuthResult
    ) async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Step 1: Authenticate with Apple/Google
            let result = try await action()
            
            // Step 2: Authenticate with backend (for Apple/Google only)
            if requiresBackendAuth {
                guard let token = result.token else {
                    showError(message: "Failed to get authentication token")
                    isLoading = false
                    return
                }
                
                // Send token to backend for validation
                let isAuthenticated = try await profileService.authenticate(token: token)
                
                guard isAuthenticated else {
                    showError(message: "Backend authentication failed")
                    isLoading = false
                    return
                }
                
                // Save token to Keychain
                try tokenStorage.saveAccessToken(token)
                try tokenStorage.saveUserIdentifier(result.userId)
            }
            
            currentAuthResult = result
            authSuccess = true
            
        } catch AuthError.cancelled {
            // User cancelled - no error message needed
        } catch let error as AuthError {
            showError(message: error.localizedDescription)
        } catch let error as APIError {
            showError(message: error.localizedDescription)
        } catch {
            showError(message: error.localizedDescription)
        }
        
        isLoading = false
    }
    
    private func showError(message: String) {
        errorMessage = message
        showError = true
    }
}
