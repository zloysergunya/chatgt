import Foundation

enum KeyValueStorageRegistry {
    
    typealias Service = KeyValueStorage
    
    
    struct Key: Hashable {
        private let id: String
        
        init(_ id: String) {
            self.id = id
        }
    }
    
    private enum ClientRegister {
        case `static`(Service)
        case dynamic(() -> Service)
    }
    
    private static var registry: [Key: ClientRegister] = [:]
    
    static func register(_ client: Service, for key: Key) {
        guard registry[key] == nil else { return }
        registry[key] = .static(client)
    }
    
    static func register(_ client: @escaping () -> Service, for key: Key) {
        guard registry[key] == nil else { return }
        registry[key] = .dynamic(client)
    }
    
    static func service(for key: Key) -> Service {
        switch registry[key] {
        case let .dynamic(client):
            client()
        case let .static(client):
            client
        case .none:
            fatalError("\(Service.self) for \(key) not found")
        }
    }
    
}

extension KeyValueStorageRegistry.Key {
    static let `default` = Self("default")
    static let shared = Self("shared")
    static let secureShared = Self("shared secure")
}
