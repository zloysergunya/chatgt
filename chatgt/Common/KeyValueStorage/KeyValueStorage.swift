import Foundation

protocol KeyValueStorage: AnyObject {
    func value<T: Decodable>(for key: String) -> T?
    func set<T: Encodable>(for key: String, newValue: T?)
    
    func allKeys() -> [String]
    func removeAll() throws
}

extension KeyValueStorage {
    func value<T: Codable>(for key: String, default defaultValue: T) -> T { value(for: key) ?? defaultValue }
}
