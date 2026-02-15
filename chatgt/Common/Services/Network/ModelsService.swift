import Foundation
import Moya

final class ModelsService {
    static let shared = ModelsService()

    private let provider: MoyaProvider<ModelsAPI>
    private let tokenRefreshService: TokenRefreshService

    init(
        provider: MoyaProvider<ModelsAPI> = NetworkManager.shared.modelsProvider,
        tokenRefreshService: TokenRefreshService = .shared
    ) {
        self.provider = provider
        self.tokenRefreshService = tokenRefreshService
    }

    func fetchModels() async throws -> [AIModel] {
        let token = try await tokenRefreshService.getValidAccessToken()

        do {
            return try await performFetchModels(token: token)
        } catch APIError.sessionExpired {
            // Session expired — propagate, UI will handle via notification
            throw APIError.sessionExpired
        } catch APIError.unauthorized {
            // Token was rejected — force refresh and retry once
            let newToken = try await tokenRefreshService.forceRefresh()
            return try await performFetchModels(token: newToken)
        }
    }

    private func performFetchModels(token: String) async throws -> [AIModel] {
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
