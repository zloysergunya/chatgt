import Foundation
import Moya

/// Service for handling profile-related API requests
final class ProfileService {

    // MARK: - Singleton

    static let shared = ProfileService()

    // MARK: - Private Properties

    private let provider: MoyaProvider<ProfileAPI>
    private let tokenRefreshService: TokenRefreshService

    // MARK: - Initialization

    init(
        provider: MoyaProvider<ProfileAPI> = NetworkManager.shared.profileProvider,
        tokenRefreshService: TokenRefreshService = .shared
    ) {
        self.provider = provider
        self.tokenRefreshService = tokenRefreshService
    }

    // MARK: - Methods

    /// Authenticate user with JWT token from Apple/Google
    /// - Parameter token: JWT token received from Apple or Google Sign-In
    /// - Returns: `true` if authentication was successful (202 Accepted)
    /// - Throws: `APIError` if authentication fails
    func authenticate(token: String) async throws -> Bool {
        return try await performAuthenticate(token: token)
    }

    /// Fetch current user profile with automatic token refresh on 401.
    /// - Parameter token: JWT token for authorization (optional; uses stored token if nil)
    /// - Returns: User profile
    /// - Throws: `APIError` if request fails
    func fetchProfile(token: String? = nil) async throws -> Profile {
        let accessToken = try await resolveToken(explicit: token)

        do {
            return try await performFetchProfile(token: accessToken)
        } catch APIError.unauthorized {
            // Token was rejected — force refresh and retry once
            let newToken = try await tokenRefreshService.forceRefresh()
            return try await performFetchProfile(token: newToken)
        }
    }

    // MARK: - Private

    private func resolveToken(explicit token: String?) async throws -> String {
        if let token { return token }
        return try await tokenRefreshService.getValidAccessToken()
    }

    private func performAuthenticate(token: String) async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.authenticate(token: token)) { result in
                switch result {
                case .success(let response):
                    if response.statusCode == 202 {
                        continuation.resume(returning: true)
                    } else if response.statusCode == 401 {
                        continuation.resume(throwing: APIError.unauthorized)
                    } else {
                        let message = String(data: response.data, encoding: .utf8)
                        continuation.resume(throwing: APIError.serverError(
                            statusCode: response.statusCode,
                            message: message
                        ))
                    }

                case .failure(let error):
                    switch error {
                    case .underlying(let underlyingError, _):
                        continuation.resume(throwing: APIError.networkError(underlyingError))
                    default:
                        continuation.resume(throwing: APIError.networkError(error))
                    }
                }
            }
        }
    }

    private func performFetchProfile(token: String) async throws -> Profile {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.getMe(token: token)) { result in
                switch result {
                case .success(let response):
                    if response.statusCode == 200 {
                        do {
                            let profile = try JSONDecoder().decode(Profile.self, from: response.data)
                            continuation.resume(returning: profile)
                        } catch {
                            continuation.resume(throwing: APIError.decodingError(error))
                        }
                    } else if response.statusCode == 401 {
                        continuation.resume(throwing: APIError.unauthorized)
                    } else {
                        let message = String(data: response.data, encoding: .utf8)
                        continuation.resume(throwing: APIError.serverError(
                            statusCode: response.statusCode,
                            message: message
                        ))
                    }

                case .failure(let error):
                    switch error {
                    case .underlying(let underlyingError, _):
                        continuation.resume(throwing: APIError.networkError(underlyingError))
                    default:
                        continuation.resume(throwing: APIError.networkError(error))
                    }
                }
            }
        }
    }
}
