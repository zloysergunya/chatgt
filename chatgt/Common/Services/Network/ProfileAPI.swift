import Foundation
import Moya
import Alamofire

enum ProfileAPI {
    case createProfile(token: String, provider: String?, code: String?)
    case getMe(token: String)
    case appleRefresh(token: String, refreshToken: String)
}

// MARK: - TargetType

extension ProfileAPI: TargetType {

    var baseURL: URL {
        URL(string: "https://chat-gt.pro")!
    }

    var path: String {
        switch self {
        case .createProfile:
            return "/api/protected/v1/profile"
        case .getMe:
            return "/api/protected/v1/profile/me"
        case .appleRefresh:
            return "/api/public/v1/token/apple/refresh"
        }
    }

    var method: Moya.Method {
        switch self {
        case .createProfile, .appleRefresh:
            return .post
        case .getMe:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .createProfile(_, let provider, let code):
            if let provider, let code {
                return .requestJSONEncodable(["provider": provider, "code": code])
            }
            return .requestPlain
        case .getMe:
            return .requestPlain
        case .appleRefresh(_, let refreshToken):
            return .requestJSONEncodable(["refreshToken": refreshToken])
        }
    }

    var headers: [String: String]? {
        switch self {
        case .createProfile(let token, _, _), .getMe(let token), .appleRefresh(let token, _):
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
