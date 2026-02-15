import Foundation
import Moya

enum AuthAPI {
    /// Exchange OAuth token for backend access + refresh tokens
    case exchangeToken(provider: String, oauthToken: String, authorizationCode: String?)
    /// Refresh the backend access token using the refresh token
    case refreshToken(refreshToken: String)
}

// MARK: - TargetType

extension AuthAPI: TargetType {

    var baseURL: URL {
        URL(string: "https://chat-gt.pro")!
    }

    var path: String {
        switch self {
        case .exchangeToken:
            return "/api/auth/v1/token"
        case .refreshToken:
            return "/api/auth/v1/token/refresh"
        }
    }

    var method: Moya.Method {
        return .post
    }

    var task: Moya.Task {
        switch self {
        case .exchangeToken(let provider, let oauthToken, let authorizationCode):
            var params: [String: Any] = [
                "provider": provider,
                "token": oauthToken
            ]
            if let code = authorizationCode {
                params["authorization_code"] = code
            }
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)

        case .refreshToken(let refreshToken):
            return .requestParameters(
                parameters: ["refresh_token": refreshToken],
                encoding: JSONEncoding.default
            )
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }

    var validationType: ValidationType {
        return .successAndRedirectCodes
    }
}

// MARK: - Token Response

/// Response from backend token exchange / refresh endpoints
struct TokenResponse: Decodable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int // seconds until access token expires

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
    }
}
