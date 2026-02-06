import Foundation
import Moya
import Alamofire

enum ModelsAPI {
    case getModels(token: String)
}

extension ModelsAPI: TargetType {
    var baseURL: URL {
        URL(string: "https://chat-gt.pro")!
    }

    var path: String {
        switch self {
        case .getModels:
            return "/api/public/v1/models"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getModels:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .getModels:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        switch self {
        case .getModels(let token):
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
