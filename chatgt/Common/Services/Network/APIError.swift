import Foundation
import RswiftResources

/// API error types for network requests
enum APIError: LocalizedError {
    case unauthorized
    case networkError(Error)
    case serverError(statusCode: Int, message: String?)
    case decodingError(Error)
    case invalidResponse
    case unknown

    var errorDescription: String? {
        switch self {
        case .unauthorized:
            return R.string.errors.unauthorized()
        case .networkError(let error):
            return R.string.errors.network(error.localizedDescription)
        case .serverError(let statusCode, let message):
            if let message = message {
                return R.string.errors.server(statusCode, message)
            }
            return R.string.errors.server_code(statusCode)
        case .decodingError(let error):
            return R.string.errors.decoding(error.localizedDescription)
        case .invalidResponse:
            return R.string.errors.invalid_response()
        case .unknown:
            return R.string.errors.unknown()
        }
    }
}
