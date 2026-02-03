import Foundation
import Moya
import Alamofire

/// Network manager for configuring and providing Moya providers
final class NetworkManager {
    
    // MARK: - Singleton
    
    static let shared = NetworkManager()
    
    // MARK: - Properties
    
    /// Moya provider for Profile API
    lazy var profileProvider: MoyaProvider<ProfileAPI> = {
        createProvider()
    }()
    
    // MARK: - Private Properties
    
    private let session: Session
    
    // MARK: - Initialization
    
    private init() {
        // Configure session with custom timeout
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        configuration.waitsForConnectivity = true
        
        session = Session(configuration: configuration)
    }
    
    // MARK: - Private Methods
    
    private func createProvider<T: TargetType>() -> MoyaProvider<T> {
        var plugins: [PluginType] = []
        
        #if DEBUG
        // Add logging plugin for debug builds
        let loggerPlugin = NetworkLoggerPlugin(configuration: .init(
            logOptions: [.requestMethod, .requestHeaders, .requestBody, .successResponseBody, .errorResponseBody]
        ))
        plugins.append(loggerPlugin)
        #endif
        
        return MoyaProvider<T>(
            session: session,
            plugins: plugins
        )
    }
}
