import Foundation

final class DummyKeyValueStorage: KeyValueStorage {

    private var data: [String: Any] = [:]
    
    init() { }
    
    func value<T>(for key: String) -> T? where T: Decodable {
        data[key] as? T
    }
    
    func set<T>(for key: String, newValue: T?) where T: Encodable {
        data[key] = newValue
    }
    
    func allKeys() -> [String] {
        data.map(\.key)
    }
    
    func removeAll() throws {
        data = [:]
    }
    
}
