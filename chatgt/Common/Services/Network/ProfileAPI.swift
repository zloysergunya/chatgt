import Foundation
import Moya
import Alamofire

/// Moya target for Profile API endpoints
enum ProfileAPI {
    /// Authenticate user with JWT token from Apple/Google
    case authenticate(token: String)
    /// Get current user profile
    case getMe(token: String)
}

// MARK: - TargetType

extension ProfileAPI: TargetType {
    
    var baseURL: URL {
        URL(string: "https://chat-gt.pro")!
    }
    
    var path: String {
        switch self {
        case .authenticate:
            return "/api/protected/v1/profile"
        case .getMe:
            return "/api/protected/v1/profile/me"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .authenticate:
            return .post
        case .getMe:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .authenticate, .getMe:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .authenticate(let token), .getMe(let token):
            return [
                "Authorization": "Bearer \(token)",
                "Content-Type": "application/json"
            ]
        }
    }
    
    var validationType: ValidationType {
        return .successAndRedirectCodes
    }
}
