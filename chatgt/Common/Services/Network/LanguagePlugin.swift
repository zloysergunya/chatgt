import Foundation
import Moya

final class LanguagePlugin: PluginType {
    func prepare(_ request: URLRequest, target: any TargetType) -> URLRequest {
        var request = request
        let code = Locale.current.language.languageCode?.identifier ?? "en"
        request.setValue(code, forHTTPHeaderField: "Accept-Language")
        return request
    }
}
