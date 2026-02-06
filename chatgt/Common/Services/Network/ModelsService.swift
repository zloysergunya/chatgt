import Foundation
import Moya

final class ModelsService {
    static let shared = ModelsService()

    private let provider: MoyaProvider<ModelsAPI>
    private let tokenStorage = TokenStorage.shared

    init(provider: MoyaProvider<ModelsAPI> = NetworkManager.shared.modelsProvider) {
        self.provider = provider
    }

    func fetchModels() async throws -> [AIModel] {
        guard let token = tokenStorage.getAccessToken() else {
            throw APIError.unauthorized
        }

        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.getModels(token: token)) { result in
                switch result {
                case .success(let response):
                    if response.statusCode == 200 {
                        do {
                            let models = try JSONDecoder().decode([AIModel].self, from: response.data)
                            continuation.resume(returning: models)
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
