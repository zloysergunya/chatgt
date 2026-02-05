import Foundation

extension UserDefaults: KeyValueStorage {
    
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        decoder.dataDecodingStrategy = .base64
        return decoder
    }()
    
    static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        encoder.dataEncodingStrategy = .base64
        return encoder
    }()
    
    func value<T: Decodable>(for key: String) -> T? {
        guard
            let data = self.string(forKey: key)?.data(using: .utf8),
            let object = try? UserDefaults.decoder.decode(T.self, from: data) as? T
        else { return nil }
        
        return object
    }
    
    func set<T: Encodable>(for key: String, newValue: T?) {
        guard
            let newValue,
            let data = try? UserDefaults.encoder.encode(newValue) as? Data,
            let value = String(data: data, encoding: .utf8)
        else { return self.removeObject(forKey: key) }
        
        self.set(value, forKey: key)
    }
    
    func allKeys() -> [String] {
        self.dictionaryRepresentation().map(\.key)
    }
    
    func removeAll() throws {
        allKeys().forEach({ self.set(nil, forKey: $0) })
    }
    
}
