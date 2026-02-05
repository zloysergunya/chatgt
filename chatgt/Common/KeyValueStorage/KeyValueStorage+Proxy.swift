import Foundation

protocol DataStoring: AnyObject {
    var datastorePrefix: String { get }
}

extension DataStoring {
    typealias PersistentStored<T: Codable> = __KVStorageProxy<Self, T>
    
    var datastorePrefix: String { "\(Self.self)." }
}

protocol PersistentStoring: DataStoring {
    var persistentStorage: KeyValueStorage { get }
}

// swiftlint:disable type_name
@propertyWrapper
final class __KVStorageProxy<EnclosingSelf: DataStoring, WrappedType: Codable> {

    private let key: String?
    private let defaultValue: WrappedType
    private let persistentStorageKeyPath: KeyPath<EnclosingSelf, KeyValueStorage>
    
    @_disfavoredOverload
    init(
        wrappedValue: WrappedType,
        storage: KeyPath<EnclosingSelf, KeyValueStorage>,
        key: String? = nil
    ) {
        self.key = key
        self.persistentStorageKeyPath = storage
        self.defaultValue = wrappedValue
    }
    
    static subscript(
        _enclosingInstance observed: EnclosingSelf,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingSelf, WrappedType>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, __KVStorageProxy>
    ) -> WrappedType {
        get {
            let _self = observed[keyPath: storageKeyPath]
            
            let persistentStorage = observed[keyPath: _self.persistentStorageKeyPath]
            
            if let key = _self.key {
                return persistentStorage.value(for: key, default: _self.defaultValue)
            } else if let key = Mirror(reflecting: observed).children.first(where: { ($0.value as? Self) === _self })?.label {
                return persistentStorage.value(for: "\(observed.datastorePrefix)\(key)", default: _self.defaultValue)
            }
            
            fatalError("Failed to get key")
        }
        set {
            
            let _self = observed[keyPath: storageKeyPath]
            
            let persistentStorage = observed[keyPath: _self.persistentStorageKeyPath]
            
            if let key = _self.key {
                return persistentStorage.set(for: key, newValue: newValue)
            } else if let key = Mirror(reflecting: observed).children.first(where: { ($0.value as? Self) === _self })?.label {
                return persistentStorage.set(for: "\(observed.datastorePrefix)\(key)", newValue: newValue)
            }
            
            fatalError("Failed to get key")
        }
    }
    
    var wrappedValue: WrappedType {
        get { fatalError("called wrappedValue getter") }
        set { fatalError("called wrappedValue setter with value \(newValue)") }
    }
    
}

extension __KVStorageProxy where EnclosingSelf: PersistentStoring {
    @_disfavoredOverload
    convenience init(
        wrappedValue: WrappedType,
        key: String? = nil
    ) {
        self.init(wrappedValue: wrappedValue, storage: \.persistentStorage, key: key)
    }
    
    convenience init<T>(key: String? = nil) where WrappedType == Optional<T> {
        self.init(wrappedValue: nil, storage: \.persistentStorage, key: key)
    }
}

extension __KVStorageProxy {
    convenience init<T>(
        storage: KeyPath<EnclosingSelf, KeyValueStorage>,
        key: String? = nil
    ) where WrappedType == Optional<T> {
        self.init(wrappedValue: nil, storage: storage, key: key)
    }
}
