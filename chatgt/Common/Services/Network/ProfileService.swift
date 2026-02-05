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
    
    /// Authenticate user with JWT token from Apple/Google
    /// - Parameter token: JWT token received from Apple or Google Sign-In
    /// - Returns: `true` if authentication was successful (202 Accepted)
    /// - Throws: `APIError` if authentication fails
    func authenticate(token: String) async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.authenticate(token: token)) { result in
                switch result {
                case .success(let response):
                    // Check for 202 Accepted status
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
