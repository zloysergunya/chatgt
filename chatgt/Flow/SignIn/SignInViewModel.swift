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

            switch result.provider {
            case .apple:
                try await handleAppleSignIn(result: result)
            case .google, .email:
                try await handleDefaultSignIn(result: result)
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

    func handleAppleSignIn(result: AuthResult) async throws {
        guard let idToken = result.token else {
            showError(message: "Failed to get Apple identity token")
            return
        }
        guard let authCode = result.authorizationCode else {
            showError(message: "Failed to get Apple authorization code")
            return
        }

        let tokenPair = try await profileService.createProfile(
            token: idToken, authProvider: "apple", code: authCode
        )

        try saveTokens(tokenPair, userId: result.userId, provider: result.provider)

        let profile = try await profileService.fetchProfile(token: tokenPair.idToken)
        profileDataStore.profile = profile
    }

    func handleDefaultSignIn(result: AuthResult) async throws {
        guard let token = result.token else {
            showError(message: "Failed to get authentication token")
            return
        }

        let tokenPair = try await profileService.createProfile(token: token)

        try saveTokens(tokenPair, userId: result.userId, provider: result.provider)

        let profile = try await profileService.fetchProfile(token: tokenPair.idToken)
        profileDataStore.profile = profile
    }

    func saveTokens(_ tokenPair: TokenPairResponse, userId: String, provider: AuthProvider) throws {
        try tokenStorage.saveAccessToken(tokenPair.idToken)
        try tokenStorage.saveRefreshToken(tokenPair.refreshToken)
        try tokenStorage.saveUserIdentifier(userId)
        try tokenStorage.saveAuthProvider(provider)
    }
    
    func showError(message: String) {
        errorMessage = message
        showError = true
    }
}
