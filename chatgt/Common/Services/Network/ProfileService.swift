import Foundation
import Moya

/// Service for handling profile-related API requests
final class ProfileService {
    
    // MARK: - Singleton
    
    static let shared = ProfileService()
    
    // MARK: - Private Properties
    
    private let provider: MoyaProvider<ProfileAPI>
    
    // MARK: - Initialization
    
    init(provider: MoyaProvider<ProfileAPI> = NetworkManager.shared.profileProvider) {
        self.provider = provider
    }
    
    // MARK: - Methods
    
    /// Create user profile and obtain tokens
    /// - Parameters:
    ///   - token: JWT token (identity token from Apple/Google)
    ///   - provider: Auth provider name (e.g. "apple"), optional
    ///   - code: Authorization code from provider, optional
    /// - Returns: Token pair with access, refresh, and id tokens
    func createProfile(token: String, authProvider: String? = nil, code: String? = nil) async throws -> TokenPairResponse {
        return try await withCheckedThrowingContinuation { continuation in
            self.provider.request(.createProfile(token: token, provider: authProvider, code: code)) { result in
                switch result {
                case .success(let response):
                    if (200...299).contains(response.statusCode) {
                        do {
                            let decoded = try JSONDecoder().decode(TokenPairResponse.self, from: response.data)
                            continuation.resume(returning: decoded)
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

    /// Refresh Apple tokens using a refresh token
    func refreshAppleToken(token: String, refreshToken: String) async throws -> TokenPairResponse {
        return try await withCheckedThrowingContinuation { continuation in
            self.provider.request(.appleRefresh(token: token, refreshToken: refreshToken)) { result in
                switch result {
                case .success(let response):
                    if (200...299).contains(response.statusCode) {
                        do {
                            let decoded = try JSONDecoder().decode(TokenPairResponse.self, from: response.data)
                            continuation.resume(returning: decoded)
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

    /// Fetch current user profile
    /// - Parameter token: JWT token for authorization
    /// - Returns: User profile
    /// - Throws: `APIError` if request fails
    func fetchProfile(token: String) async throws -> Profile {
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

struct TokenPairResponse: Decodable {
    let refreshToken: String
    let idToken: String
}
