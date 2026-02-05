import Foundation
import Combine

@MainActor
final class SignInViewModel: ObservableObject {
        
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    @Published var authSuccess: Bool = false
    @Published var currentAuthResult: AuthResult?
        
    private let googleAuthService: GoogleAuthService
    private let appleAuthService: AppleAuthService
    private let emailAuthService: EmailAuthService
    private let profileService: ProfileService
    private let tokenStorage: TokenStorage
    private let profileDataStore: StoresProfile
    
    init(
        googleAuthService: GoogleAuthService = .shared,
        appleAuthService: AppleAuthService = .shared,
        emailAuthService: EmailAuthService = .shared,
        profileService: ProfileService = .shared,
        tokenStorage: TokenStorage = .shared,
        profileDataStore: StoresProfile = ProfileDataStore()
    ) {
        self.googleAuthService = googleAuthService
        self.appleAuthService = appleAuthService
        self.emailAuthService = emailAuthService
        self.profileService = profileService
        self.tokenStorage = tokenStorage
        self.profileDataStore = profileDataStore
    }
    
    func signInWithGoogle() async {
        await performSignIn() {
            try await self.googleAuthService.signIn()
        }
    }
    
    func signInWithApple() async {
        await performSignIn() {
            try await self.appleAuthService.signIn()
        }
    }
    
    func signInWithEmail(email: String, password: String) async {
        await performSignIn() {
            try await self.emailAuthService.signIn(email: email, password: password)
        }
    }
    
    func signUpWithEmail(email: String, password: String, displayName: String? = nil) async {
        await performSignIn() {
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
            try await googleAuthService.signOut()
            try await appleAuthService.signOut()
            try await emailAuthService.signOut()

            try tokenStorage.clearAll()
            profileDataStore.profile = nil

            currentAuthResult = nil
            authSuccess = false
        } catch {
            showError(message: error.localizedDescription)
        }
        
        isLoading = false
    }
}

private extension SignInViewModel {
    func performSignIn(action: @escaping () async throws -> AuthResult) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await action()
            
            guard let token = result.token else {
                showError(message: "Failed to get authentication token")
                isLoading = false
                return
            }
            
            let isAuthenticated = try await profileService.authenticate(token: token)
            
            guard isAuthenticated else {
                showError(message: "Backend authentication failed")
                isLoading = false
                return
            }
            
            try tokenStorage.saveAccessToken(token)
            try tokenStorage.saveUserIdentifier(result.userId)

            // Fetch and save user profile
            let profile = try await profileService.fetchProfile(token: token)
            profileDataStore.profile = profile

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
    
    func showError(message: String) {
        errorMessage = message
        showError = true
    }
}
