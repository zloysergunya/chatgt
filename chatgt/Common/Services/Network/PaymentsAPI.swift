import Foundation
import Moya
import Alamofire

enum PaymentsAPI {
    case processApplePayment(token: String, transaction: String)
}

// MARK: - TargetType

extension PaymentsAPI: TargetType {

    var baseURL: URL {
        URL(string: "https://chat-gt.pro")!
    }

    var path: String {
        switch self {
        case .processApplePayment:
            return "/api/protected/v1/payments/APPLE_PAY"
        }
    }

    var method: Moya.Method {
        switch self {
        case .processApplePayment:
            return .post
        }
    }

    var task: Moya.Task {
        switch self {
        case .processApplePayment(_, let transaction):
            return .requestJSONEncodable(["transaction": transaction])
        }
    }

    var headers: [String: String]? {
        switch self {
        case .processApplePayment(let token, _):
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
