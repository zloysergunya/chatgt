import KeychainAccess
import Foundation

extension Keychain: KeyValueStorage {
    
    func value<T: Decodable>(for key: String) -> T? {
        if
            let data = self[key]?.data(using: .utf8),
            let object = try? JSONDecoder().decode(T.self, from: data)
        {
            return object
        } else if
            let str = self[key],
            T.self == String.self
        {
            return str as! T
        }
        
        return nil
    }
    
    func set<T: Encodable>(for key: String, newValue: T?) {
        guard
            let newValue,
            let data = try? JSONEncoder().encode(newValue),
            let value = String(data: data, encoding: .utf8)
        else { return self[key] = nil }
        
        self[key] = value
    }
}
