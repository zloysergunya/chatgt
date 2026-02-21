import Foundation
import Moya

/// Service for handling payment-related API requests
final class PaymentService {

    // MARK: - Singleton

    static let shared = PaymentService()

    // MARK: - Private Properties

    private let provider: MoyaProvider<PaymentsAPI>

    // MARK: - Initialization

    init(provider: MoyaProvider<PaymentsAPI> = NetworkManager.shared.paymentsProvider) {
        self.provider = provider
    }

    // MARK: - Methods

    /// Send Apple Pay transaction to backend for validation
    /// - Parameter transaction: JWS representation of the StoreKit transaction
    /// - Throws: `APIError` if the request fails
    func processPayment(transaction: String) async throws {
        guard let token = TokenStorage.shared.getAccessToken() else {
            throw APIError.unauthorized
        }

        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.processApplePayment(token: token, transaction: transaction)) { result in
                switch result {
                case .success(let response):
                    if (200...299).contains(response.statusCode) {
                        continuation.resume()
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
