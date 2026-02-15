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
    private let authNetworkService: AuthNetworkService
    private let tokenStorage: TokenStorage
    private let tokenRefreshService: TokenRefreshService
    private let profileDataStore: StoresProfile

    init(
        googleAuthService: GoogleAuthService = .shared,
        appleAuthService: AppleAuthService = .shared,
        emailAuthService: EmailAuthService = .shared,
        profileService: ProfileService = .shared,
        authNetworkService: AuthNetworkService = .shared,
        tokenStorage: TokenStorage = .shared,
        tokenRefreshService: TokenRefreshService = .shared,
        profileDataStore: StoresProfile = ProfileDataStore()
    ) {
        self.googleAuthService = googleAuthService
        self.appleAuthService = appleAuthService
        self.emailAuthService = emailAuthService
        self.profileService = profileService
        self.authNetworkService = authNetworkService
        self.tokenStorage = tokenStorage
        self.tokenRefreshService = tokenRefreshService
        self.profileDataStore = profileDataStore
    }

    func signInWithGoogle() async {
        await performSignIn {
            try await self.googleAuthService.signIn()
        }
    }

    func signInWithApple() async {
        await performSignIn {
            try await self.appleAuthService.signIn()
        }
    }

    func signInWithEmail(email: String, password: String) async {
        await performSignIn {
            try await self.emailAuthService.signIn(email: email, password: password)
        }
    }

    func signUpWithEmail(email: String, password: String, displayName: String? = nil) async {
        await performSignIn {
            try await self.emailAuthService.signUp(email: email, password: password, displayName: displayName)
        }
    }

    func resetPassword(email: String) async {
        isLoading = true
        errorMessage = nil

        do {
            try await emailAuthService.resetPassword(email: email)
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

            guard let oauthToken = result.token else {
                showError(message: "Failed to get authentication token")
                isLoading = false
                return
            }

            // Exchange the OAuth token for backend access + refresh tokens
            let tokenResponse = try await authNetworkService.exchangeToken(
                oauthToken: oauthToken,
                provider: result.provider,
                authorizationCode: result.authorizationCode
            )

            // Save backend tokens and metadata
            await tokenRefreshService.saveTokens(from: tokenResponse, provider: result.provider)
            try tokenStorage.saveUserIdentifier(result.userId)

            // Fetch and save user profile using the new backend access token
            let profile = try await profileService.fetchProfile(token: tokenResponse.accessToken)
            profileDataStore.profile = profile

            currentAuthResult = result
            authSuccess = true

        } catch AuthError.cancelled {
            // User cancelled — no error message needed
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
