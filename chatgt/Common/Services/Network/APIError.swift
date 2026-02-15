import Foundation

/// API error types for network requests
enum APIError: LocalizedError {
    case unauthorized
    case sessionExpired
    case networkError(Error)
    case serverError(statusCode: Int, message: String?)
    case decodingError(Error)
    case invalidResponse
    case unknown

    var errorDescription: String? {
        switch self {
        case .unauthorized:
            return "Unauthorized. Please sign in again."
        case .sessionExpired:
            return "Your session has expired. Please sign in again."
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .serverError(let statusCode, let message):
            if let message = message {
                return "Server error (\(statusCode)): \(message)"
            }
            return "Server error: \(statusCode)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid server response"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}
