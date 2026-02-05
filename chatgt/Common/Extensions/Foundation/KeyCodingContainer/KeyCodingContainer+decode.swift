import Foundation

public extension KeyedDecodingContainer {

    func decode<T: Decodable>(forKey key: Key) throws -> T {
        try self.decode(T.self, forKey: key)
    }
    
    func decodeIfPresent<T: Decodable>(forKey key: Key) throws -> T? {
        try self.decodeIfPresent(T.self, forKey: key)
    }
}
